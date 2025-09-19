#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Lua批量处理工具 - 图形界面版
功能：读取toc文件，合并Lua文件，压缩代码，更新toc并生成加密值
"""

import os
import sys
import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
from datetime import datetime
import subprocess

# 确保中文显示正常
import io
# 只有在sys.stdout和sys.stderr不是None时才修改其编码（解决PyInstaller打包后可能为None的问题）
if hasattr(sys.stdout, 'buffer'):
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
if hasattr(sys.stderr, 'buffer'):
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

class LuaBatchProcessor:
    def __init__(self):
        self.logs = []
    
    def log(self, message, is_error=False):
        """记录日志信息"""
        timestamp = datetime.now().strftime('%H:%M:%S')
        log_entry = f"[{timestamp}] {message}"
        self.logs.append(log_entry)
        print(log_entry, file=sys.stderr if is_error else sys.stdout)
        return log_entry
    
    def xor_cipher(self, input_str, key_str='YSY'):
        """异或加密函数（完全匹配Lua版实现）"""
        if not isinstance(input_str, str) or not key_str:
            return None
        
        result = []
        key_len = len(key_str)
        input_len = len(input_str)
        
        # 注意Lua的索引从1开始
        for i in range(1, input_len + 1):
            char_byte = ord(input_str[i - 1])
            # 计算key的索引，与Lua的mod函数行为一致
            key_index = ((i - 1) % key_len) + 1
            key_byte = ord(key_str[key_index - 1])
            encrypted_byte = char_byte ^ key_byte
            result.append(chr(encrypted_byte))
        
        return ''.join(result)
    
    def simple_base64_encode(self, input_str):
        """Base64编码函数（完全匹配Lua版实现）"""
        if not isinstance(input_str, str):
            return None
        
        # Base64字符表
        b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        result = ''
        bytes_list = []
        input_len = len(input_str)
        
        # 将字符串转换为字节序列（保留所有字符，包括ASCII值为0的字符）
        for i in range(input_len):
            byte_val = ord(input_str[i])
            bytes_list.append(byte_val)
        
        bytes_len = len(bytes_list)
        i = 1  # 注意：这里从1开始，与Lua索引一致
        
        while i <= bytes_len:
            # 获取三个字节，不足的用0填充
            c1 = bytes_list[i-1] if i <= bytes_len else 0
            c2 = bytes_list[i] if (i + 1 <= bytes_len) else 0
            c3 = bytes_list[i+1] if (i + 2 <= bytes_len) else 0
            
            # 计算四个 Base64 索引 (0-63) - 完全匹配Lua的位运算
            b1 = (c1 >> 2) & 0x3F  # c1的高6位
            b2 = ((c1 & 3) << 4) | ((c2 >> 4) & 0x0F)  # c1低2位拼c2高4位
            b3 = ((c2 & 15) << 2) | ((c3 >> 6) & 0x03)  # c2低4位拼c3高2位
            b4 = c3 & 63  # c3的低6位
            
            # 完全匹配Lua的剩余字节数计算方式
            remaining_bytes = bytes_len - i + 1
            
            result += b[b1]
            
            # 严格按照Lua的逻辑处理剩余字节
            if remaining_bytes == 1:
                # 只剩1个有效字节 (c1)
                result += b[b2] + '=='
            elif remaining_bytes == 2:
                # 只剩2个有效字节 (c1, c2)
                result += b[b2] + b[b3] + '='
            else:
                # 剩3个或以上有效字节 (c1, c2, c3)
                result += b[b2] + b[b3] + b[b4]
            
            i += 3
        
        return result
    
    def generate_encryption_value(self, player_name):
        """生成加密值"""
        if not player_name:
            return False, "错误: 请提供姓名或工会名称！"
        
        xor_encrypted = self.xor_cipher(player_name, 'YSY')
        base64_encrypted = self.simple_base64_encode(xor_encrypted)
        
        result = []
        result.append(f"生成的加密值: {base64_encrypted}")
        result.append("\n生成的键值对（请手动添加到相应表中）：")
        result.append("1. BUFFString表：")
        result.append(f'["{base64_encrypted}"] = "Interface\\Icons\\[图标路径]",')
        result.append("\n2. 姓名/工会名称表：")
        result.append(f'["{player_name}"] = true,')
        
        return True, '\n'.join(result)
    
    def extract_lua_files_from_toc(self, toc_path):
        """从TOC文件中提取Lua文件列表"""
        if not os.path.exists(toc_path):
            self.log(f"错误: TOC文件不存在: {toc_path}", is_error=True)
            return []
        
        lua_files = []
        try:
            with open(toc_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
            
            for line in lines:
                line = line.strip()
                # 跳过注释和空行
                if line.startswith('#') or line == '':
                    continue
                
                # 查找.lua文件引用
                if line.lower().endswith('.lua'):
                    lua_files.append(line)
            
        except Exception as e:
            self.log(f"读取TOC文件时出错: {str(e)}", is_error=True)
            return []
        
        return lua_files
    
    def merge_lua_files(self, addon_folder, lua_files):
        """合并Lua文件内容"""
        merged_content = f"-- 合并的Lua文件\n-- 生成时间: {datetime.now().isoformat()}\n\n"
        
        for lua_file in lua_files:
            file_path = os.path.join(addon_folder, lua_file)
            if os.path.exists(file_path):
                try:
                    self.log(f"读取文件: {lua_file}")
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                    merged_content += f"\n-- 开始: {lua_file}\n"
                    merged_content += content
                    merged_content += f"\n-- 结束: {lua_file}\n"
                except Exception as e:
                    self.log(f"读取文件 {lua_file} 时出错: {str(e)}", is_error=True)
            else:
                self.log(f"警告: 文件不存在: {file_path}")
        
        return merged_content
    
    def minify_lua_code(self, code):
        """压缩Lua代码 - 简单实现"""
        # 注意：这是一个简化的压缩实现，实际项目中可以考虑使用更复杂的Lua解析器
        lines = code.split('\n')
        minified_lines = []
        
        for line in lines:
            # 移除行注释
            comment_index = line.find('--')
            if comment_index != -1 and (comment_index == 0 or line[comment_index-1].isspace()):
                line = line[:comment_index].rstrip()
            
            # 移除多余空格和制表符
            line = ' '.join(line.split())
            
            if line:
                minified_lines.append(line)
        
        # 连接所有行
        minified_code = ' '.join(minified_lines)
        
        # 移除多余的分号
        minified_code = minified_code.replace('; ', '')
        
        # 移除括号内的空格
        minified_code = minified_code.replace('( ', '(')
        minified_code = minified_code.replace(' )', ')')
        minified_code = minified_code.replace('[ ', '[')
        minified_code = minified_code.replace(' ]', ']')
        minified_code = minified_code.replace('{ ', '{')
        minified_code = minified_code.replace(' }', '}')
        
        # 移除运算符周围的空格
        for op in ['+', '-', '*', '/', '%', '=', '<', '>', '~', ',', ';', ':', '.']:
            minified_code = minified_code.replace(f' {op} ', op)
            minified_code = minified_code.replace(f' {op}', op)
            minified_code = minified_code.replace(f'{op} ', op)
        
        return minified_code
    
    def merge_lua_files_uncompressed(self, lua_files):
        """合并Lua文件为未压缩格式，保留注释和格式"""
        if not lua_files:
            return ""
        
        merged_content = []
        
        # 添加文件头信息
        merged_content.append("-- Contra插件合并文件")
        merged_content.append(f"-- 生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        merged_content.append("-- 包含文件列表:")
        
        # 收集所有版权注释
        copyright_comments = []
        
        for lua_file in lua_files:
            # 获取文件绝对路径
            if isinstance(lua_file, str):
                file_path = lua_file
            else:
                file_path = str(lua_file)
                
            if os.path.exists(file_path):
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                    
                    # 提取版权注释
                    lines = content.split('\n')
                    for line in lines[:10]:  # 检查前10行
                        if '版权' in line or 'copyright' in line.lower() or 'Copyright' in line:
                            if line.strip() not in copyright_comments:
                                copyright_comments.append(line.strip())
                    
                    # 添加文件标识
                    merged_content.append(f"\n-- ===== {os.path.basename(file_path)} =====")
                    
                    # 添加文件内容（保留所有非空行）
                    file_lines = content.split('\n')
                    for line in file_lines:
                        if line.strip():  # 只保留非空行
                            merged_content.append(line.rstrip())
                    
                except Exception as e:
                    merged_content.append(f"-- 错误: 无法读取文件 {file_path}: {str(e)}")
            else:
                merged_content.append(f"-- 警告: 文件不存在: {file_path}")
        
        # 在文件开头添加版权信息
        if copyright_comments:
            merged_content.insert(3, "")
            merged_content.insert(4, "-- 版权声明:")
            for comment in copyright_comments:
                merged_content.insert(5, f"-- {comment}")
        
        # 清理多余的空行
        final_content = []
        empty_line_count = 0
        
        for line in merged_content:
            if line.strip() == "":
                empty_line_count += 1
                if empty_line_count <= 2:  # 最多保留2个连续空行
                    final_content.append(line)
            else:
                empty_line_count = 0
                final_content.append(line)
        
        return '\n'.join(final_content)

    def update_toc(self, toc_path):
        """更新TOC文件（保留原Lua文件引用）"""
        if not os.path.exists(toc_path):
            self.log(f"错误: TOC文件不存在: {toc_path}", is_error=True)
            return None
        
        try:
            with open(toc_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            lines = content.split('\n')
            updated_lines = []
            added_contra_lua = False
            
            # 检查是否已包含Contra.lua
            for line in lines:
                trimmed_line = line.strip()
                if trimmed_line.lower() == 'contra.lua':
                    added_contra_lua = True
                    break
            
            # 如果没有Contra.lua，则添加它
            if not added_contra_lua:
                # 保留所有原始行
                updated_lines = lines.copy()
                # 找到最后一个非空且非注释行的位置
                insert_pos = len(updated_lines)
                for i in range(len(updated_lines) - 1, -1, -1):
                    trimmed_line = updated_lines[i].strip()
                    if trimmed_line != '' and not trimmed_line.startswith('#'):
                        insert_pos = i + 1
                        break
                
                updated_lines.insert(insert_pos, 'Contra.lua')
            else:
                # 已经有Contra.lua，直接返回原内容
                updated_lines = lines
            
            updated_content = '\n'.join(updated_lines)
            return updated_content
            
        except Exception as e:
            self.log(f"更新TOC文件时出错: {str(e)}", is_error=True)
            return None
    
    def extract_random_icon_from_db(self, db_file_path):
        """从数据库内容中提取随机图标"""
        if not os.path.exists(db_file_path):
            self.log(f"警告: 数据库文件不存在: {db_file_path}")
            return 'Interface\\Icons\\Temp'
        
        try:
            import re
            import random
            
            with open(db_file_path, 'r', encoding='utf-8', errors='ignore') as f:
                db_content = f.read()
            
            # 使用正则表达式匹配图标路径
            icon_regex = r'icon"\]="(Interface\\Icons\\[^"]+)"'
            icons = re.findall(icon_regex, db_content)
            
            if not icons:
                # 如果没有找到图标，返回一个默认图标
                return 'Interface\\Icons\\Temp'
            
            # 随机选择一个图标
            random_index = random.randint(0, len(icons) - 1)
            return icons[random_index]
            
        except Exception as e:
            self.log(f"提取图标时出错: {str(e)}", is_error=True)
            return 'Interface\\Icons\\Temp'
    
    def create_release_folder_structure(self, addon_folder):
        """创建发布版目录结构"""
        try:
            # 确保addon_folder是绝对路径
            addon_folder = os.path.abspath(addon_folder)
            self.log(f"使用插件文件夹绝对路径: {addon_folder}")
            
            # 创建发布版目录
            release_folder = os.path.join(addon_folder, "发布版")
            self.log(f"尝试创建发布版目录: {release_folder}")
            
            # 确保目录存在
            if not os.path.exists(release_folder):
                os.makedirs(release_folder)
                self.log(f"已创建发布版目录")
            else:
                self.log(f"发布版目录已存在")
                
            # 在发布版中创建Contra文件夹
            contra_folder = os.path.join(release_folder, "Contra")
            self.log(f"尝试创建Contra目录: {contra_folder}")
            
            if not os.path.exists(contra_folder):
                os.makedirs(contra_folder)
                self.log(f"已创建Contra目录")
            else:
                self.log(f"Contra目录已存在")
            
            # 验证目录是否真的存在
            if not os.path.exists(contra_folder):
                self.log(f"错误: 创建目录失败，目录不存在: {contra_folder}", is_error=True)
                return None
                
            return contra_folder
        except Exception as e:
            self.log(f"创建目录结构时出错: {str(e)}", is_error=True)
            self.log(f"错误类型: {type(e).__name__}", is_error=True)
            self.log(f"插件文件夹路径: {addon_folder}", is_error=True)
            return None
    
    def create_zip_file(self, contra_folder, addon_folder):
        """创建压缩包"""
        import zipfile
        from datetime import datetime
        
        # 获取发布版目录（Contra文件夹的父目录）
        release_folder = os.path.dirname(contra_folder)
        # 生成当前时间格式的文件名
        current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
        zip_filename = f"CONTRA-发布-{current_time}.zip"
        zip_path = os.path.join(release_folder, zip_filename)
        
        try:
            with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
                # 获取Contra文件夹的父目录（即发布版目录）
                release_folder = os.path.dirname(contra_folder)
                # 遍历Contra文件夹下的所有文件
                for root, _, files in os.walk(contra_folder):
                    for file in files:
                        file_path = os.path.join(root, file)
                        # 使用相对于发布版目录的路径作为zip内的路径
                        zip_relative_path = os.path.relpath(file_path, release_folder)
                        zipf.write(file_path, zip_relative_path)
            
            self.log(f"已创建压缩包: {zip_path}")
            return zip_path
        except Exception as e:
            self.log(f"创建压缩包时出错: {str(e)}", is_error=True)
            return None

    def process_folder(self, addon_folder, player_name=None):
        """处理插件文件夹"""
        if not addon_folder or not os.path.isdir(addon_folder):
            self.log(f"错误: 无效的文件夹路径: {addon_folder}", is_error=True)
            return False, None

        self.log(f"正在处理文件夹: {addon_folder}")

        # 创建发布版目录结构（包含Contra子文件夹）
        contra_folder = self.create_release_folder_structure(addon_folder)
        
        # 检查目录创建是否成功
        if not contra_folder or not os.path.exists(contra_folder):
            self.log(f"错误: 无法创建发布版目录结构", is_error=True)
            return False, None

        try:
            # 查找TOC文件
            toc_files = [f for f in os.listdir(addon_folder) if f.lower().endswith('.toc')]
            
            if not toc_files:
                self.log("错误: 未找到TOC文件", is_error=True)
                return False, None
            
            # 使用第一个TOC文件
            toc_file = toc_files[0]
            toc_path = os.path.join(addon_folder, toc_file)
            self.log(f"找到TOC文件: {toc_file}")
            
            # 提取Lua文件列表
            lua_files = self.extract_lua_files_from_toc(toc_path)
            
            if not lua_files:
                self.log("警告: 未在TOC文件中找到Lua文件")
            else:
                self.log(f"找到 {len(lua_files)} 个Lua文件")
            
            # 合并Lua文件（但不保存为Contra-all）
            merged_content = self.merge_lua_files(addon_folder, lua_files)
            
            # 生成合并未压缩文件Contra_ALL.lua
            contra_all_path = os.path.join(contra_folder, 'Contra_ALL.lua')
            # 构建完整的文件路径列表
            full_lua_paths = [os.path.join(addon_folder, lua_file) for lua_file in lua_files]
            contra_all_content = self.merge_lua_files_uncompressed(full_lua_paths)
            with open(contra_all_path, 'w', encoding='utf-8') as f:
                f.write(contra_all_content)
            self.log(f"已保存合并未压缩文件: {contra_all_path}")
            
            # 压缩Lua代码
            minified_content = self.minify_lua_code(merged_content)
            
            # 保存压缩后的文件到发布版/Contra目录
            minified_file_path = os.path.join(contra_folder, 'Contra.lua')
            with open(minified_file_path, 'w', encoding='utf-8') as f:
                f.write(minified_content)
            self.log(f"已保存压缩文件: {minified_file_path}")
            
            # 更新TOC文件
            updated_toc_content = self.update_toc(toc_path)
            if updated_toc_content:
                # 保存为新的TOC文件到发布版/Contra目录（直接使用原文件名）
                new_toc_path = os.path.join(contra_folder, toc_file)
                with open(new_toc_path, 'w', encoding='utf-8') as f:
                    f.write(updated_toc_content)
                self.log(f"已保存更新后的TOC文件: {new_toc_path}")
            
            # 如果提供了玩家名称，生成加密值
            encryption_result = None
            if player_name:
                self.log(f"\n正在为玩家 '{player_name}' 生成加密值...")
                success, encryption_result = self.generate_encryption_value(player_name)
                if success:
                    self.log(encryption_result)
            
            self.log("\n操作指南:")
            self.log("1. 生成并记录加密值（如果需要）")
            self.log("2. 手动将加密值添加到相应的表中")
            self.log("3. 重启魔兽世界客户端加载更新后的插件")
            
            # 创建压缩包
            zip_path = self.create_zip_file(contra_folder, addon_folder)
            
            return True, encryption_result
            
        except Exception as e:
            self.log(f"处理过程中发生错误: {str(e)}", is_error=True)
            return False, None

class LuaBatchProcessorGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Lua批量处理工具")
        self.root.geometry("800x600")
        
        # 设置中文字体
        self.font = ("SimHei", 10)
        
        # 创建处理器实例
        self.processor = LuaBatchProcessor()
        
        # 创建界面元素
        self.create_widgets()
    
    def browse_folder(self):
        """浏览并选择文件夹"""
        try:
            # 打开文件夹选择对话框
            selected_folder = filedialog.askdirectory(title="选择插件文件夹")
            
            # 如果用户选择了文件夹
            if selected_folder:
                # 更新文件夹显示
                self.folder_var.set(selected_folder)
        except Exception as e:
            messagebox.showerror("错误", f"浏览文件夹时出错: {str(e)}")
            
    def create_widgets(self):
        # 创建主框架
        main_frame = tk.Frame(self.root, padx=10, pady=10)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # 当前文件夹显示区域
        folder_frame = tk.Frame(main_frame)
        folder_frame.pack(fill=tk.X, pady=(0, 10))
        
        tk.Label(folder_frame, text="当前处理文件夹:", font=self.font).pack(side=tk.LEFT, padx=(0, 5))
        
        # 确定默认目录：如果是EXE打包运行，使用当前工作目录；否则使用脚本所在目录
        try:
            # 检查是否是PyInstaller打包的EXE
            if hasattr(sys, '_MEIPASS'):
                # EXE模式下使用当前工作目录作为默认值
                default_dir = os.getcwd()
            else:
                # 脚本模式下使用脚本所在目录
                default_dir = os.path.dirname(os.path.abspath(__file__))
        except Exception:
            # 发生任何异常都使用当前工作目录
            default_dir = os.getcwd()
        
        self.folder_var = tk.StringVar(value=default_dir)
        folder_entry = tk.Entry(folder_frame, textvariable=self.folder_var, width=50, font=self.font, state='readonly')
        folder_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 5))
        
        # 添加浏览按钮
        browse_btn = tk.Button(folder_frame, text="浏览...", command=self.browse_folder, font=self.font)
        browse_btn.pack(side=tk.LEFT)
        
        # 玩家名称输入区域
        name_frame = tk.Frame(main_frame)
        name_frame.pack(fill=tk.X, pady=(0, 10))
        
        tk.Label(name_frame, text="姓名/工会名称:", font=self.font).pack(side=tk.LEFT, padx=(0, 5))
        
        self.name_var = tk.StringVar()
        name_entry = tk.Entry(name_frame, textvariable=self.name_var, width=30, font=self.font)
        name_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        # 按钮区域
        btn_frame = tk.Frame(main_frame)
        btn_frame.pack(fill=tk.X, pady=(0, 10))
        
        generate_btn = tk.Button(btn_frame, text="生成加密值", command=self.generate_encryption, font=self.font, width=15)
        generate_btn.pack(side=tk.LEFT, padx=(0, 10))
        
        process_btn = tk.Button(btn_frame, text="处理当前文件夹", command=self.process_folder, font=self.font, width=15)
        process_btn.pack(side=tk.LEFT)
        
        # 加密结果区域
        result_frame = tk.LabelFrame(main_frame, text="加密结果", font=self.font)
        result_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        self.result_text = scrolledtext.ScrolledText(result_frame, wrap=tk.WORD, font=self.font, height=8)
        self.result_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.result_text.config(state=tk.DISABLED)
        
        # 日志区域
        log_frame = tk.LabelFrame(main_frame, text="处理日志", font=self.font)
        log_frame.pack(fill=tk.BOTH, expand=True)
        
        self.log_text = scrolledtext.ScrolledText(log_frame, wrap=tk.WORD, font=self.font)
        self.log_text.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.log_text.config(state=tk.DISABLED)
    

    
    def append_log(self, message):
        """在日志区域添加消息"""
        self.log_text.config(state=tk.NORMAL)
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)
        self.log_text.config(state=tk.DISABLED)
        # 强制更新界面
        self.root.update_idletasks()
    
    def set_result(self, result):
        """设置加密结果"""
        self.result_text.config(state=tk.NORMAL)
        self.result_text.delete(1.0, tk.END)
        self.result_text.insert(tk.END, result)
        self.result_text.config(state=tk.DISABLED)
    
    def generate_encryption(self):
        """生成加密值"""
        player_name = self.name_var.get().strip()
        if not player_name:
            messagebox.showerror("错误", "请先输入姓名或工会名称！")
            return
        
        # 清空日志和结果
        self.log_text.config(state=tk.NORMAL)
        self.log_text.delete(1.0, tk.END)
        self.log_text.config(state=tk.DISABLED)
        
        self.append_log(f"正在为 '{player_name}' 生成加密值...")
        
        try:
            # 重置处理器的日志
            self.processor = LuaBatchProcessor()
            
            # 生成加密值
            success, result = self.processor.generate_encryption_value(player_name)
            
            # 显示结果
            self.set_result(result)
            
            # 更新日志
            for log_entry in self.processor.logs:
                self.append_log(log_entry)
            
            if success:
                messagebox.showinfo("成功", "加密值生成成功！")
            else:
                messagebox.showwarning("警告", result)
            
        except Exception as e:
            self.append_log(f"生成加密值时出错: {str(e)}")
            messagebox.showerror("错误", f"生成加密值时出错: {str(e)}")
    
    def process_folder(self):
        """处理文件夹"""
        # 获取用户在GUI中选择的文件夹路径
        addon_folder = self.folder_var.get().strip()
        player_name = self.name_var.get().strip()
        
        # 验证文件夹是否存在
        if not addon_folder or not os.path.exists(addon_folder):
            messagebox.showerror("错误", "请先选择一个有效的插件文件夹！")
            return
        
        # 清空日志和结果
        self.log_text.config(state=tk.NORMAL)
        self.log_text.delete(1.0, tk.END)
        self.log_text.config(state=tk.DISABLED)
        
        self.result_text.config(state=tk.NORMAL)
        self.result_text.delete(1.0, tk.END)
        self.result_text.config(state=tk.DISABLED)
        
        self.append_log(f"开始处理文件夹: {addon_folder}")
        
        try:
            # 重置处理器的日志
            self.processor = LuaBatchProcessor()
            
            # 处理文件夹
            success, encryption_result = self.processor.process_folder(addon_folder, player_name)
            
            # 如果有加密结果，显示它
            if encryption_result:
                self.set_result(encryption_result)
            
            # 更新日志
            for log_entry in self.processor.logs:
                self.append_log(log_entry)
            
            if success:
                messagebox.showinfo("成功", "文件夹处理完成！")
            else:
                messagebox.showwarning("警告", "文件夹处理过程中出现问题！")
            
        except Exception as e:
            self.append_log(f"处理文件夹时出错: {str(e)}")
            messagebox.showerror("错误", f"处理文件夹时出错: {str(e)}")

def main():
    """主函数"""
    # 在Windows系统上隐藏CMD窗口
    if sys.platform == 'win32':
        import ctypes
        ctypes.windll.user32.ShowWindow(ctypes.windll.kernel32.GetConsoleWindow(), 0)
    
    root = tk.Tk()
    # 设置中文字体支持
    if sys.platform == 'win32':
        # Windows系统
        root.option_add("*Font", "SimHei 10")
    else:
        # 其他系统
        root.option_add("*Font", "WenQuanYi Micro Hei 10")
    
    # 创建GUI实例
    app = LuaBatchProcessorGUI(root)
    
    # 运行主循环
    root.mainloop()

if __name__ == '__main__':
    main()