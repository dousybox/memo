# 代码托管平台的密钥配置

## 代码平台托管 ssh 密钥

当我们下载代码托管平台上的仓库时，一般都是用 https 协议的链接来进行。虽然很方便，但是每次推送代码时都需要手动输入用户名和密码。

大部分代码托管平台都支持通过 ssh 协议来来访问远程仓库。使用 ssh 协议可以免去手动输入用户名和密码的过程，让身份验证过程能够自动化地完成。

我们要做的事情就是使用特定的工具生成一对密钥文件,并将公钥文件中的内容复制下来，然后粘贴到代码托管平台上你的账户信息设置里面的 ssh 密钥配置项中即可。

### 生成 ssh 密钥

下面的 bash 脚本 `genarate-ssh-key.sh` 用于生成一个新的 4096 位长的 rsa 密钥。

<<< @/code-hosting/example/genarate-ssh-key.sh

脚本最开始会要求你输入一个`密钥名`， 它会被用于生成密钥的标签信息以及密钥的文件名。
标签信息形如 `主机名@密钥名` 的文本,生成的私钥文件将被命名为`${密钥名}_rsa`，而公钥文件会被命名为`${密钥名}_rsa.pub`。密钥对文件会被输出到 `~/.ssh/` 目录下。

输入完`密钥名`之后，会提示你继续输入密钥的安全码。这里可以不使用安全码，直接回车跳过就行。

最后脚本会将新生成的公钥文件中的内容复制到粘贴板中。

至此，你就可以直接在平台的用户设置那里，把公钥的内容粘贴到 ssh 密钥的配置项就可以进行下一步了。

### 配置 ssh 私钥

修改 `~/.ssh/config` 文件内容，同时为不同的站点配置使用不同的密钥对。

```apacheconf
# gitfoo
Host gitfoo.com
  Preferredauthentications publickey
  IdentityFile ~/.ssh/gitfoo_rsa

# gitbar
Host gitbar.com
  Preferredauthentications publickey
  IdentityFile ~/.ssh/gitbar_rsa
```

### 测试 ssh 连接

```bash
ssh -T git@github.com
```

## 代码平台托管 GPG 密钥

GPG 密钥可以用于对 `git` 中的一些操作进行`签名`，经过签名后的操作记录信息就能被用于验证这些操作都是本人亲自完成的。

通常会被签名的操作有：提交代码用的 `git commit` 和新增版本标签的 `git tag` 操作。

### 生成 GPG 密钥

下面 bash 脚本 `genarate-gpg-key.sh`用于生成一个新的签名密钥。
并在密钥生成完成，会将新公钥的内容复制到粘贴板。

<<< @/code-hosting/example/genarate-ssh-key.sh

查询密钥

```
$ gpg --list-secret-keys --keyid-format LONG
/c/Users/Dousy/.gnupg/pubring.kbx
---------------------------------
sec   rsa4096/5ADB14522B7E19C8 2020-02-18 [SC] [expires: 2021-02-17]
      5E67A26FBF1B908788A620345ADB14522B7E19C8
uid                 [ultimate] Dousy (D-NOTE@github) <dousybox@gmail.com>
ssb   rsa4096/51A269BD6542CBB5 2020-02-18 [E] [expires: 2021-02-17]

sec   rsa4096/51F68D69793407BE 2020-02-18 [SC] [expires: 2021-02-17]
      468D565FE9E9ADFAE0932B2B51F68D69793407BE
uid                 [ultimate] Dousy (D-NOTE@gitlab) <dousybox@gmail.com>
ssb   rsa4096/4570189DB294558D 2020-02-18 [E] [expires: 2021-02-17]

sec   rsa4096/950862AD724DD1F5 2020-02-18 [SC]
      495B2F865F2BFBF8EBFE049B950862AD724DD1F5
uid                 [ultimate] tester (test) <teser@g.com>
ssb   rsa4096/54E2A32AD0780B70 2020-02-18 [E]
```

### 配置 GPG 密钥

#### 配置 git 关联 GPG 密钥

```bash
git config --global user.signingKey 3AA5C34371567BD2
```

#### 配置 git commit 开启签名

可以配置当前仓库的 `git commit` 操作都开启 GPG 签名动作。

```bash
git config  commit.gpgSign true
```

也可以配置全局所有仓库的 `git commit` 操作都开启 GPG 签名动作。

```bash
git config --global commit.gpgSign true
```

#### 配置 git tag 开启签名

可以配置当前仓库的 `git tag` 操作都开启 GPG 签名动作。

```bash
git config --global tag.gpgSign true
```

也可以配置全局所有仓库的 `git tag` 操作都开启 GPG 签名动作。

```bash
git config tag.gpgSign true
```
