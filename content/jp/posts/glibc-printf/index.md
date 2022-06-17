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
// stdio-common/vfprintf-internal.c
# define vfprintf	__vfprintf_internal
...
int
vfprintf (FILE *s, const CHAR_T *format, va_list ap, unsigned int mode_flags)
{
  ...
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

```c
// stdio-common/vfprintf-internal.c
static int
printf_positional (FILE *s, const CHAR_T *format, int readonly_format,
		   va_list ap, va_list *ap_savep, int done, int nspecs_done,
		   const UCHAR_T *lead_str_end,
		   CHAR_T *work_buffer, int save_errno,
		   const char *grouping, THOUSANDS_SEP_T thousands_sep,
		   unsigned int mode_flags)
```

```c
// stdio-common/vfprintf-internal.c
# define PUT(F, S, N)	_IO_sputn ((F), (S), (N))
...
static inline int
outstring_func (FILE *s, const UCHAR_T *string, size_t length, int done)
{
  assert ((size_t) done <= (size_t) INT_MAX);
  if ((size_t) PUT (s, string, length) != (size_t) (length))
    return -1;
  return done_add_func (length, done);
}

#define outstring(String, Len)						\
  do									\
    {									\
      const void *string_ = (String);					\
      done = outstring_func (s, string_, (Len), done);			\
      if (done < 0)							\
	goto all_done;							\
    }									\
   while (0)
```

```c

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
