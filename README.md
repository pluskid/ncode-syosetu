# ncode-syosetu

ncode.syosetu.com content to epub converter.

## Install
```
# gem install ncode-syosetu
```

## Usage
```
$ ncode2epub.rb n0000aa # http://ncode.syosetu/com/n0000aa -> n0000aa.epub
$ ncode2mobi.rb n0000aa # http://ncode.syosetu/com/n0000aa -> n0000aa.mobi
```

## Install MeCab and natto

When MeCab and natto is installed, the script will try to automatically annotate all kanji with their pronunciations.

Download MeCab from [here](http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html). When compiling MeCab, make sure `configure` with the option `--enable-utf8-only`. When compiling the dictionaries, make sure `configure` with the option `--with-charset=utf8`. After this, please download and install the Ruby binding of MeCab, called [natto](https://bitbucket.org/buruzaemon/natto/).