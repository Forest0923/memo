---
title: "Shell Script Cheat Sheet"
draft: false
weight: 10
---
## Array

- Test code:

```bash
#!/bin/sh

array=(0 1 2 3)
echo $array
echo ${array[0]}
echo ${array[@]}
```

- Output:

```text
0
0
0 1 2
```

## if

- Test code:

```bash
#!/bin/sh

val0=0
val1=1

#
if [ $val0 = 0 ]; then
	echo val0 = 0
elif [ $val0 = 1 ]; then
	echo val0 = 1
else
	echo otherwise
fi

# AND
if [ $val0 = 0 ] && [ $val1 != 1 ]; then
	echo true
else
	echo false
fi

# OR
if [ $val0 = 1 ] || [ $val1 = 1 ]; then
	echo true
else
	echo false
fi


file=foo.txt
dir=bar

# Existing of file or dir
if [ -f ${file} ] && [ -d ${dir} ]; then
	echo true
else
	echo false
fi
```

- Output:

```text
val0 = 0
false
true
false
```

## for

- Test code:

```bash
#!/bin/sh

array=(0 1 2)

#
for i in `seq 10`; do
	echo $i
done

#
for j in ${array[@]}; do
	echo $j
done
```

- Output:

```text
1
2
3
4
5
6
7
8
9
10
0
1
2
```

## Input

- Test code:

```sh
echo -n "input  > "
read VAR
echo "output > $VAR"
```

- Output:

```text
input  > hello
output > hello
```

## Function

- Definition:

```sh
func() {
	echo hello
}

func_arg() {
	echo "arg1 = $1, arg2 = $2"
}
```
