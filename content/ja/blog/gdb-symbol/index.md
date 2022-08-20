+++
title = "GDB Symbol"
description = "GDB のシンボルの扱いについて調べたときの雑なメモ"
date = 2022-06-30T11:48:54+09:00
tags = [
  "GDB", "debug"
]
categories = [
  "GDB Code Reading"
]
draft = false
+++

## Version

- Source code: https://sourceware.org/git/binutils-gdb.git
- GDB v13.0

## Data Structures

File: gdb/symtab.h

```c
struct symbol : public general_symbol_info, public allocate_on_obstack
{
  symbol ()
    /* Class-initialization of bitfields is only allowed in C++20.  */
    : m_domain (UNDEF_DOMAIN),
      m_aclass_index (0),
      m_is_objfile_owned (1),
      m_is_argument (0),
      m_is_inlined (0),
      maybe_copied (0),
      subclass (SYMBOL_NONE),
      m_artificial (false)
    {
      /* We can't use an initializer list for members of a base class, and
	 general_symbol_info needs to stay a POD type.  */
      m_name = nullptr;
      m_value.ivalue = 0;
      language_specific.obstack = nullptr;
      m_language = language_unknown;
      ada_mangled = 0;
      m_section = -1;
      /* GCC 4.8.5 (on CentOS 7) does not correctly compile class-
	 initialization of unions, so we initialize it manually here.  */
      owner.symtab = nullptr;
    }

  ...

  /* Return the symtab of this symbol.  It is an error to call this if
     is_objfile_owned is false, which only happens for
     architecture-provided types.  */

  struct symtab *symtab () const;

  /* Set the symtab of this symbol to SYMTAB.  It is an error to call
     this if is_objfile_owned is false, which only happens for
     architecture-provided types.  */

  void set_symtab (struct symtab *symtab);

  ...

  union
  {
    /* The symbol table containing this symbol.  This is the file associated
       with LINE.  It can be NULL during symbols read-in but it is never NULL
       during normal operation.  */
    struct symtab *symtab;

    /* For types defined by the architecture.  */
    struct gdbarch *arch;
  } owner;

  /* Domain code.  */

  ENUM_BITFIELD(domain_enum) m_domain : SYMBOL_DOMAIN_BITS;

  /* Address class.  This holds an index into the 'symbol_impls'
     table.  The actual enum address_class value is stored there,
     alongside any per-class ops vectors.  */

  unsigned int m_aclass_index : SYMBOL_ACLASS_BITS;

  /* If non-zero then symbol is objfile-owned, use owner.symtab.
       Otherwise symbol is arch-owned, use owner.arch.  */

  unsigned int m_is_objfile_owned : 1;

  ...
};
```

```c
/* Each source file or header is represented by a struct symtab.
   The name "symtab" is historical, another name for it is "filetab".
   These objects are chained through the `next' field.  */

struct symtab
{
  struct compunit_symtab *compunit () const
  {
    return m_compunit;
  }

  void set_compunit (struct compunit_symtab *compunit)
  {
    m_compunit = compunit;
  }

  struct linetable *linetable () const
  {
    return m_linetable;
  }

  void set_linetable (struct linetable *linetable)
  {
    m_linetable = linetable;
  }

  enum language language () const
  {
    return m_language;
  }

  void set_language (enum language language)
  {
    m_language = language;
  }

  /* Unordered chain of all filetabs in the compunit,  with the exception
     that the "main" source file is the first entry in the list.  */

  struct symtab *next;

  /* Backlink to containing compunit symtab.  */

  struct compunit_symtab *m_compunit;

  /* Table mapping core addresses to line numbers for this file.
     Can be NULL if none.  Never shared between different symtabs.  */

  struct linetable *m_linetable;

  /* Name of this source file.  This pointer is never NULL.  */

  const char *filename;

  /* Language of this source file.  */

  enum language m_language;

  /* Full name of file as found by searching the source path.
     NULL if not yet known.  */

  char *fullname;
};
```

File: gdb/symtab.c

```c
/* Check for a symtab of a specific name by searching some symtabs.
   This is a helper function for callbacks of iterate_over_symtabs.

   If NAME is not absolute, then REAL_PATH is NULL
   If NAME is absolute, then REAL_PATH is the gdb_realpath form of NAME.

   The return value, NAME, REAL_PATH and CALLBACK are identical to the
   `map_symtabs_matching_filename' method of quick_symbol_functions.

   FIRST and AFTER_LAST indicate the range of compunit symtabs to search.
   Each symtab within the specified compunit symtab is also searched.
   AFTER_LAST is one past the last compunit symtab to search; NULL means to
   search until the end of the list.  */

bool
iterate_over_some_symtabs (const char *name,
			   const char *real_path,
			   struct compunit_symtab *first,
			   struct compunit_symtab *after_last,
			   gdb::function_view<bool (symtab *)> callback)
{
  struct compunit_symtab *cust;
  const char* base_name = lbasename (name);

  for (cust = first; cust != NULL && cust != after_last; cust = cust->next)
    {
      for (symtab *s : cust->filetabs ())
	{
	  if (compare_filenames_for_search (s->filename, name))
	    {
	      if (callback (s))
		return true;
	      continue;
	    }

	  /* Before we invoke realpath, which can get expensive when many
	     files are involved, do a quick comparison of the basenames.  */
	  if (! basenames_may_differ
	      && FILENAME_CMP (base_name, lbasename (s->filename)) != 0)
	    continue;

	  if (compare_filenames_for_search (symtab_to_fullname (s), name))
	    {
	      if (callback (s))
		return true;
	      continue;
	    }

	  /* If the user gave us an absolute path, try to find the file in
	     this symtab and use its absolute path.  */
	  if (real_path != NULL)
	    {
	      const char *fullname = symtab_to_fullname (s);

	      gdb_assert (IS_ABSOLUTE_PATH (real_path));
	      gdb_assert (IS_ABSOLUTE_PATH (name));
	      gdb::unique_xmalloc_ptr<char> fullname_real_path
		= gdb_realpath (fullname);
	      fullname = fullname_real_path.get ();
	      if (FILENAME_CMP (real_path, fullname) == 0)
		{
		  if (callback (s))
		    return true;
		  continue;
		}
	    }
	}
    }

  return false;
}

/* Check for a symtab of a specific name; first in symtabs, then in
   psymtabs.  *If* there is no '/' in the name, a match after a '/'
   in the symtab filename will also work.

   Calls CALLBACK with each symtab that is found.  If CALLBACK returns
   true, the search stops.  */

void
iterate_over_symtabs (const char *name,
		      gdb::function_view<bool (symtab *)> callback)
{
  gdb::unique_xmalloc_ptr<char> real_path;

  /* Here we are interested in canonicalizing an absolute path, not
     absolutizing a relative path.  */
  if (IS_ABSOLUTE_PATH (name))
    {
      real_path = gdb_realpath (name);
      gdb_assert (IS_ABSOLUTE_PATH (real_path.get ()));
    }

  for (objfile *objfile : current_program_space->objfiles ())
    {
      if (iterate_over_some_symtabs (name, real_path.get (),
				     objfile->compunit_symtabs, NULL,
				     callback))
	return;
    }

  /* Same search rules as above apply here, but now we look thru the
     psymtabs.  */

  for (objfile *objfile : current_program_space->objfiles ())
    {
      if (objfile->map_symtabs_matching_filename (name, real_path.get (),
						  callback))
	return;
    }
}

/* A wrapper for iterate_over_symtabs that returns the first matching
   symtab, or NULL.  */

struct symtab *
lookup_symtab (const char *name)
{
  struct symtab *result = NULL;

  iterate_over_symtabs (name, [&] (symtab *symtab)
    {
      result = symtab;
      return true;
    });

  return result;
}
```