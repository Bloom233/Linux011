AS := as
LD := ld -m elf_x86_64
LDFLAGS := -Ttext 0x0 -s --oformat binary

image: linux.img
	@echo "Generating image... ok!"  # 输出生成镜像成功的消息

linux.img: bootsect setup
	bootsect setup > $@
#@cat bootsect setup > $@  # 使用 cat 合并二进制文件 [4](@ref)

#> 是重定向符号，将 cat 的输出从 ​​stdout 重定向到文件
#cat 在合并文件时​​仅按字节顺序拼接原始内容​​，不会在文件之间插入任何分隔符（如换行符 \n）。

bootsect: bootsect.o
	$(LD) $(LDFLAGS) -o $@ $<

bootsect.o: bootsect.S
	$(AS) -o $@ $<

setup: setup.o
	$(LD) $(LDFLAGS) -o _start_setup -o $@ $<  # 使用 -o _start_setup 生成可执行文件
# 这里的 _start_setup 是一个标签，表示程序入口点
# 该标签在 setup.S 中定义，通常用于指定程序的起始执行点
# 生成的 setup 文件将包含 _start_setup 标签指向的代码
# 这里的 -o $@ 表示将输出文件命名为 setup
# 该命令将 setup.S 汇编成可执行文件 setup，并指定入口点为 _start_setup
# 注意：如果 setup.S 中没有定义 _start 标签，可以
# 移除 -o _start_setup 参数，直接使用 -o $@
# 这样会生成一个没有指定入口点的可执行文件 setup
# 如果 setup.S 中确实有 _start 标签，则可以保留该参数
# 这样可以确保生成的可执行文件在运行时从 _start 标签开始
# 运行时从 _start 标签开始执行代码
# 这里的 -o $@ 表示将输出文件命名为 setup
# 该命令将 setup.S 汇编成可执行文件 setup，并指定入口点为 _start_setup
# 注意：如果 setup.S 中没有定义 _start 标签，可以
# 移除 -o _start_setup 参数，直接使用 -o $@
# 这样会生成一个没有指定入口点的可执行文件 setup
# 如果 setup.S 中确实有 _start 标签，则可以保留该参数
# 这样可以确保生成的可执行文件在运行时从 _start 标签开始
# 运行时从 _start 标签开始执行代码
##$(LD) $(LDFLAGS) -o $@ $<  # 移除冗余的 `-e _start_setup`（需确保汇编文件有 _start 标签）

setup.o: setup.S
	$(AS) -o $@ $<

#$(AS)：​​汇编器变量​​，通常定义为 as（如 AS := as）。
#$@：​​自动变量​​，代表当前目标文件名（即 setup.o）。
#$<：​​自动变量​​，代表第一个依赖文件名（即 setup.S
#等效命令​ as -o setup.o setup.S

clean:
	rm -f *.o
	rm -f bootsect
	rm -f setup
	rm -f linux.img