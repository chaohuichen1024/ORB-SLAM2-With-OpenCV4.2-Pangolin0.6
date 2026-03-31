# =========================
# 1. 更新软件源
# =========================
# 作用：刷新apt索引，确保后续安装的是最新版本依赖
sudo apt update

# =========================
# 2. 安装OpenGL相关库
# =========================
# Pangolin是基于OpenGL的可视化库，这一步是核心依赖
sudo apt install -y libgl1-mesa-dev \        # 提供OpenGL核心开发接口
                    libglew-dev              # OpenGL扩展加载库（必须）

# =========================
# 3. 安装Boost库
# =========================
# Pangolin内部使用Boost做线程和文件管理
sudo apt install -y libboost-dev \           # Boost基础库
                    libboost-thread-dev \   # 多线程支持
                    libboost-filesystem-dev # 文件系统操作

# =========================
# 4. 安装FFmpeg相关库
# =========================
# Pangolin支持视频流输入（SLAM常用），不装会编译失败
sudo apt install -y ffmpeg \                 # 编解码工具（调试用）
                    libavcodec-dev \        # 编码解码核心库
                    libavutil-dev \         # 工具库
                    libavformat-dev \       # 视频封装格式
                    libswscale-dev          # 图像格式转换

# =========================
# 5. 安装图像库
# =========================
# 用于纹理、截图等功能
sudo apt install -y libpng-dev

# =========================
# 6. 安装构建工具和数学库
# =========================
# cmake：构建系统
# pkg-config：查找依赖路径
# eigen：线性代数库（SLAM核心依赖）
sudo apt install -y cmake pkg-config libeigen3-dev

# =========================
# 7. 下载Pangolin源码
# =========================
# 官方仓库
git clone https://github.com/stevenlovegrove/Pangolin.git

# 进入源码目录
cd Pangolin

# =========================
# 8. 切换到稳定版本 v0.6
# =========================
# ⚠️ 非常关键：master版本经常编译失败（C++兼容问题）
git checkout v0.6

# =========================
# 9. 创建build目录（规范做法）
# =========================
# 避免污染源码目录
mkdir build
cd build

# =========================
# 10. 生成Makefile
# =========================
# 检查依赖并配置编译环境
cmake ..

# =========================
# 11. 编译
# =========================
# 使用所有CPU核心加速编译
make -j$(nproc)

# =========================
# 12. 安装到系统
# =========================
# 默认安装到 /usr/local
# 否则其他程序（如ORB-SLAM2）无法找到Pangolin
sudo make install

# =========================
# 13. 刷新动态库
# =========================
# 否则运行程序时可能报：
# error while loading shared libraries
sudo ldconfig

# =========================
# 14. 进入示例程序目录
# =========================
# 用于验证是否安装成功
cd ../examples/HelloPangolin

# =========================
# 15. 编译示例程序
# =========================
mkdir build
cd build

cmake ..
make

# =========================
# 16. 运行示例
# =========================
./HelloPangolin

# =========================
# 成功标志
# =========================
# 如果看到一个弹出的窗口，里面有一个旋转的彩色立方体
# 说明Pangolin安装成功
#
# 常见失败原因：
# 1. Docker没开GUI（X11问题）
# 2. OpenGL驱动缺失
# 3. 依赖未安装完整
# =========================