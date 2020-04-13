<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# How to use patch and patch files

## Create patch file

* You can simply generate a patch file with git.

```
git diff > test.patch
```

## Add comments on the patch file

* Surprisingly, You can make a comment each diff file lines with a character '#'.
* See this example.

```diff
diff --git a/vocabulary.md b/vocabulary.md
index f7db1c0..0ef2a41 100644
--- a/vocabulary.md
+++ b/vocabulary.md
@@ -355,3 +355,7 @@ what's the opposite of disparity?
 
 ---
 
+The name-value-pair string consists of the characters up to, but not including, the first ';'
+';' 을 포함하지 않는 바로 전까지 name-value-pair 이고
+
+';' 가 없다면, 전체가 name-value-pair 이다.
# I am the comment!!!!!!!!!!!!!!!!!!!!!

```

## Apply the patch file with 'patch' command

* After generating patch file (ex: test.patch). You can apply this patch file on your repository.
* First, Locate your patch file at the root of the repository.
* Second, Command this.

```bash
patch -p1 < test.patch
```

* Third, Check your diff with 'git diff'

