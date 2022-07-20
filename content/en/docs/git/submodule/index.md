---
title: "Submodule"
draft: false
weight: 40
---
The submodule is a feature that allows you to include another Git repository as a sub directory in your repository. If you want to use the contents of a library or another project you are developing, you can include it in the project while managing it separately from the main project.

### **Adding Submodule**

To add a submodule, use the following command.

```sh
git submodule add
```

The information of the repository added as a submodule is described in .gitmodules.

### **Cloning a Repository Containing Submodule**

If you clone a repository containing submodules in the same way as a normal repository, the submodule directory will be empty. If you want to clone the submodules together, use the `--recursive` option as follows.

```sh
git clone --recursive git@github.com:user/repo.git
```

If you have already cloned the main project and want to clone the contents of the sub-modules, execute the following command.

```sh
git submodule init
git submodule update
```

### **Updating Submodule**

The first way to apply updates to the submodule is to go to the submodule directory and fetch and merge them.

```sh
cd submod
git fetch
git merge
```

The second method is to use `submodule update` as follows.

```sh
git submodule update --remote
```

If you update a local submodule, move to the submodule directory, commit, and push.

### **Remove Submodule**

If you want to remove a submodule, first run deinit.

```sh
git submodule deinit submoddir
```

Next, remove the subdirectory from git with the following command.

```sh
git rm --cached submoddir
```

Finally, commit to reflect the changes.

```sh
git commit
```
