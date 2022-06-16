+++
title = "glibc printf"
description = ""
date = 2022-06-16T13:16:58+09:00
tags = [
  "glibc"
]
categories = [
  "glibc Code Reading"
]
menu = "main"
draft = false
+++

## Version

- glibc v2.35

## Definition1

```c
// stdio-common/printf.c
int
__printf (const char *format, ...)
{
  va_list arg;
  int done;

  va_start (arg, format);
  done = __vfprintf_internal (stdout, format, arg, 0);
  va_end (arg);

  return done;
}

#undef _IO_printf
ldbl_strong_alias (__printf, printf);
ldbl_strong_alias (__printf, _IO_printf);
```

```c
```c
// stdio-common/vfprintf-internal.c
# define vfprintf	__vfprintf_internal
...
int
vfprintf (FILE *s, const CHAR_T *format, va_list ap, unsigned int mode_flags)
{
  /* The character used as thousands separator.  */
  THOUSANDS_SEP_T thousands_sep = 0;

  /* The string describing the size of groups of digits.  */
  const char *grouping;

  /* Place to accumulate the result.  */
  int done;

  /* Current character in format string.  */
  const UCHAR_T *f;

  /* End of leading constant string.  */
  const UCHAR_T *lead_str_end;

  /* Points to next format specifier.  */
  const UCHAR_T *end_of_spec;

  /* Buffer intermediate results.  */
  CHAR_T work_buffer[WORK_BUFFER_SIZE];
  CHAR_T *workend;

  /* We have to save the original argument pointer.  */
  va_list ap_save;

  /* Count number of specifiers we already processed.  */
  int nspecs_done;

  /* For the %m format we may need the current `errno' value.  */
  int save_errno = errno;

  /* 1 if format is in read-only memory, -1 if it is in writable memory,
     0 if unknown.  */
  int readonly_format = 0;

  /* Orient the stream.  */
#ifdef ORIENT
  ORIENT;
#endif

  /* Sanity check of arguments.  */
  ARGCHECK (s, format);

#ifdef ORIENT
  /* Check for correct orientation.  */
  if (_IO_vtable_offset (s) == 0
      && _IO_fwide (s, sizeof (CHAR_T) == 1 ? -1 : 1)
      != (sizeof (CHAR_T) == 1 ? -1 : 1))
    /* The stream is already oriented otherwise.  */
    return EOF;
#endif

  if (UNBUFFERED_P (s))
    /* Use a helper function which will allocate a local temporary buffer
       for the stream and then call us again.  */
    return buffered_vfprintf (s, format, ap, mode_flags);

  /* Initialize local variables.  */
  done = 0;
  grouping = (const char *) -1;
#ifdef __va_copy
  /* This macro will be available soon in gcc's <stdarg.h>.  We need it
     since on some systems `va_list' is not an integral type.  */
  __va_copy (ap_save, ap);
#else
  ap_save = ap;
#endif
  nspecs_done = 0;

#ifdef COMPILE_WPRINTF
  /* Find the first format specifier.  */
  f = lead_str_end = __find_specwc ((const UCHAR_T *) format);
#else
  /* Find the first format specifier.  */
  f = lead_str_end = __find_specmb ((const UCHAR_T *) format);
#endif

  /* Lock stream.  */
  _IO_cleanup_region_start ((void (*) (void *)) &_IO_funlockfile, s);
  _IO_flockfile (s);

  /* Write the literal text before the first format.  */
  outstring ((const UCHAR_T *) format,
	     lead_str_end - (const UCHAR_T *) format);

  /* If we only have to print a simple string, return now.  */
  if (*f == L_('\0'))
    goto all_done;

  /* Use the slow path in case any printf handler is registered.  */
  if (__glibc_unlikely (__printf_function_table != NULL
			|| __printf_modifier_table != NULL
			|| __printf_va_arg_table != NULL))
    goto do_positional;

  /* Process whole format string.  */
  do
    {
      STEP0_3_TABLE;
      STEP4_TABLE;

      int is_negative;	/* Flag for negative number.  */
      union
      {
	unsigned long long int longlong;
	unsigned long int word;
      } number;
      int base;
      union printf_arg the_arg;
      CHAR_T *string;	/* Pointer to argument string.  */
      int alt = 0;	/* Alternate format.  */
      int space = 0;	/* Use space prefix if no sign is needed.  */
      int left = 0;	/* Left-justify output.  */
      int showsign = 0;	/* Always begin with plus or minus sign.  */
      int group = 0;	/* Print numbers according grouping rules.  */
      /* Argument is long double/long long int.  Only used if
	 double/long double or long int/long long int are distinct.  */
      int is_long_double __attribute__ ((unused)) = 0;
      int is_short = 0;	/* Argument is short int.  */
      int is_long = 0;	/* Argument is long int.  */
      int is_char = 0;	/* Argument is promoted (unsigned) char.  */
      int width = 0;	/* Width of output; 0 means none specified.  */
      int prec = -1;	/* Precision of output; -1 means none specified.  */
      /* This flag is set by the 'I' modifier and selects the use of the
	 `outdigits' as determined by the current locale.  */
      int use_outdigits = 0;
      UCHAR_T pad = L_(' ');/* Padding character.  */
      CHAR_T spec;

      workend = work_buffer + WORK_BUFFER_SIZE;

      /* Get current character in format string.  */
      JUMP (*++f, step0_jumps);

      /* ' ' flag.  */
    LABEL (flag_space):
      space = 1;
      JUMP (*++f, step0_jumps);

      /* '+' flag.  */
    LABEL (flag_plus):
      showsign = 1;
      JUMP (*++f, step0_jumps);

      /* The '-' flag.  */
    LABEL (flag_minus):
      left = 1;
      pad = L_(' ');
      JUMP (*++f, step0_jumps);

      /* The '#' flag.  */
    LABEL (flag_hash):
      alt = 1;
      JUMP (*++f, step0_jumps);

      /* The '0' flag.  */
    LABEL (flag_zero):
      if (!left)
	pad = L_('0');
      JUMP (*++f, step0_jumps);

      /* The '\'' flag.  */
    LABEL (flag_quote):
      group = 1;

      if (grouping == (const char *) -1)
	{
#ifdef COMPILE_WPRINTF
	  thousands_sep = _NL_CURRENT_WORD (LC_NUMERIC,
					    _NL_NUMERIC_THOUSANDS_SEP_WC);
#else
	  thousands_sep = _NL_CURRENT (LC_NUMERIC, THOUSANDS_SEP);
#endif

	  grouping = _NL_CURRENT (LC_NUMERIC, GROUPING);
	  if (*grouping == '\0' || *grouping == CHAR_MAX
#ifdef COMPILE_WPRINTF
	      || thousands_sep == L'\0'
#else
	      || *thousands_sep == '\0'
#endif
	      )
	    grouping = NULL;
	}
      JUMP (*++f, step0_jumps);

    LABEL (flag_i18n):
      use_outdigits = 1;
      JUMP (*++f, step0_jumps);

      /* Get width from argument.  */
    LABEL (width_asterics):
      {
	const UCHAR_T *tmp;	/* Temporary value.  */

	tmp = ++f;
	if (ISDIGIT (*tmp))
	  {
	    int pos = read_int (&tmp);

	    if (pos == -1)
	      {
		__set_errno (EOVERFLOW);
		done = -1;
		goto all_done;
	      }

	    if (pos && *tmp == L_('$'))
	      /* The width comes from a positional parameter.  */
	      goto do_positional;
	  }
	width = va_arg (ap, int);

	/* Negative width means left justified.  */
	if (width < 0)
	  {
	    width = -width;
	    pad = L_(' ');
	    left = 1;
	  }
      }
      JUMP (*f, step1_jumps);

      /* Given width in format string.  */
    LABEL (width):
      width = read_int (&f);

      if (__glibc_unlikely (width == -1))
	{
	  __set_errno (EOVERFLOW);
	  done = -1;
	  goto all_done;
	}

      if (*f == L_('$'))
	/* Oh, oh.  The argument comes from a positional parameter.  */
	goto do_positional;
      JUMP (*f, step1_jumps);

    LABEL (precision):
      ++f;
      if (*f == L_('*'))
	{
	  const UCHAR_T *tmp;	/* Temporary value.  */

	  tmp = ++f;
	  if (ISDIGIT (*tmp))
	    {
	      int pos = read_int (&tmp);

	      if (pos == -1)
		{
		  __set_errno (EOVERFLOW);
		  done = -1;
		  goto all_done;
		}

	      if (pos && *tmp == L_('$'))
		/* The precision comes from a positional parameter.  */
		goto do_positional;
	    }
	  prec = va_arg (ap, int);

	  /* If the precision is negative the precision is omitted.  */
	  if (prec < 0)
	    prec = -1;
	}
      else if (ISDIGIT (*f))
	{
	  prec = read_int (&f);

	  /* The precision was specified in this case as an extremely
	     large positive value.  */
	  if (prec == -1)
	    {
	      __set_errno (EOVERFLOW);
	      done = -1;
	      goto all_done;
	    }
	}
      else
	prec = 0;
      JUMP (*f, step2_jumps);

      /* Process 'h' modifier.  There might another 'h' following.  */
    LABEL (mod_half):
      is_short = 1;
      JUMP (*++f, step3a_jumps);

      /* Process 'hh' modifier.  */
    LABEL (mod_halfhalf):
      is_short = 0;
      is_char = 1;
      JUMP (*++f, step4_jumps);

      /* Process 'l' modifier.  There might another 'l' following.  */
    LABEL (mod_long):
      is_long = 1;
      JUMP (*++f, step3b_jumps);

      /* Process 'L', 'q', or 'll' modifier.  No other modifier is
	 allowed to follow.  */
    LABEL (mod_longlong):
      is_long_double = 1;
      is_long = 1;
      JUMP (*++f, step4_jumps);

    LABEL (mod_size_t):
      is_long_double = sizeof (size_t) > sizeof (unsigned long int);
      is_long = sizeof (size_t) > sizeof (unsigned int);
      JUMP (*++f, step4_jumps);

    LABEL (mod_ptrdiff_t):
      is_long_double = sizeof (ptrdiff_t) > sizeof (unsigned long int);
      is_long = sizeof (ptrdiff_t) > sizeof (unsigned int);
      JUMP (*++f, step4_jumps);

    LABEL (mod_intmax_t):
      is_long_double = sizeof (intmax_t) > sizeof (unsigned long int);
      is_long = sizeof (intmax_t) > sizeof (unsigned int);
      JUMP (*++f, step4_jumps);

      /* Process current format.  */
      while (1)
	{
#define process_arg_int() va_arg (ap, int)
#define process_arg_long_int() va_arg (ap, long int)
#define process_arg_long_long_int() va_arg (ap, long long int)
#define process_arg_pointer() va_arg (ap, void *)
#define process_arg_string() va_arg (ap, const char *)
#define process_arg_unsigned_int() va_arg (ap, unsigned int)
#define process_arg_unsigned_long_int() va_arg (ap, unsigned long int)
#define process_arg_unsigned_long_long_int() va_arg (ap, unsigned long long int)
#define process_arg_wchar_t() va_arg (ap, wchar_t)
#define process_arg_wstring() va_arg (ap, const wchar_t *)
	  process_arg ();
	  process_string_arg ();
#undef process_arg_int
#undef process_arg_long_int
#undef process_arg_long_long_int
#undef process_arg_pointer
#undef process_arg_string
#undef process_arg_unsigned_int
#undef process_arg_unsigned_long_int
#undef process_arg_unsigned_long_long_int
#undef process_arg_wchar_t
#undef process_arg_wstring

	LABEL (form_float):
	LABEL (form_floathex):
	  {
	    if (__glibc_unlikely ((mode_flags & PRINTF_LDBL_IS_DBL) != 0))
	      is_long_double = 0;

	    struct printf_info info =
	      {
		.prec = prec,
		.width = width,
		.spec = spec,
		.is_long_double = is_long_double,
		.is_short = is_short,
		.is_long = is_long,
		.alt = alt,
		.space = space,
		.left = left,
		.showsign = showsign,
		.group = group,
		.pad = pad,
		.extra = 0,
		.i18n = use_outdigits,
		.wide = sizeof (CHAR_T) != 1,
		.is_binary128 = 0
	      };

	    PARSE_FLOAT_VA_ARG_EXTENDED (info);
	    const void *ptr = &the_arg;

	    int function_done = __printf_fp_spec (s, &info, &ptr);
	    if (function_done < 0)
	      {
		done = -1;
		goto all_done;
	      }
	    done_add (function_done);
	  }
	  break;

	LABEL (form_unknown):
	  if (spec == L_('\0'))
	    {
	      /* The format string ended before the specifier is complete.  */
	      __set_errno (EINVAL);
	      done = -1;
	      goto all_done;
	    }

	  /* If we are in the fast loop force entering the complicated
	     one.  */
	  goto do_positional;
	}

      /* The format is correctly handled.  */
      ++nspecs_done;

      /* Look for next format specifier.  */
#ifdef COMPILE_WPRINTF
      f = __find_specwc ((end_of_spec = ++f));
#else
      f = __find_specmb ((end_of_spec = ++f));
#endif

      /* Write the following constant string.  */
      outstring (end_of_spec, f - end_of_spec);
    }
  while (*f != L_('\0'));

  /* Unlock stream and return.  */
  goto all_done;

  /* Hand off processing for positional parameters.  */
do_positional:
  done = printf_positional (s, format, readonly_format, ap, &ap_save,
			    done, nspecs_done, lead_str_end, work_buffer,
			    save_errno, grouping, thousands_sep, mode_flags);

 all_done:
  /* Unlock the stream.  */
  _IO_funlockfile (s);
  _IO_cleanup_region_end (0);

  return done;
}
```

## Definition2

```c
// libio/bits/stdio2.h
__fortify_function int
printf (const char *__restrict __fmt, ...)
{
  return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
}
```

```c
// sysdeps/ieee754/ldbl-opt/nldbl-printf_chk.c
int
attribute_hidden
__printf_chk (int flag, const char *fmt, ...)
{
  va_list arg;
  int done;

  va_start (arg, fmt);
  done = __nldbl___vfprintf_chk (stdout, flag, fmt, arg);
  va_end (arg);

  return done;
}
```

```c
// sysdeps/ieee754/ldbl-opt/nldbl-compat.c
int
attribute_compat_text_section
__nldbl___vfprintf_chk (FILE *s, int flag, const char *fmt, va_list ap)
{
  unsigned int mode = PRINTF_LDBL_IS_DBL;
  if (flag > 0)
    mode |= PRINTF_FORTIFY;

  return __vfprintf_internal (s, fmt, ap, mode);
}
```

## Definition3

```c
// sysdeps/ieee754/ldbl-opt/nldbl-printf.c
int
attribute_hidden
printf (const char *fmt, ...)
{
  va_list arg;
  int done;

  va_start (arg, fmt);
  done = __nldbl_vfprintf (stdout, fmt, arg);
  va_end (arg);

  return done;
}
```

```c
// sysdeps/ieee754/ldbl-opt/nldbl-compat.c
int
attribute_compat_text_section
__nldbl_vfprintf (FILE *s, const char *fmt, va_list ap)
{
  return __vfprintf_internal (s, fmt, ap, PRINTF_LDBL_IS_DBL);
}
strong_alias (__nldbl_vfprintf, __nldbl__IO_vfprintf)
```
