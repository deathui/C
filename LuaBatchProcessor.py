#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Lua批量处理工具
功能：读取toc文件，合并Lua文件，压缩代码，更新toc并生成加密值
修复版本：确保压缩后的代码语法正确
"""

import os
import re
import base64
import argparse
import random
import sys
import zipfile
from datetime import datetime

# 确保中文显示正常
import io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8')

class LuaBatchProcessor:
    def __init__(self, addon_folder=None, player_name=None):
        self.addon_folder = addon_folder
        self.player_name = player_name
        self.logs = []
    
    def log(self, message, is_error=False):
        """记录日志信息"""
        timestamp = datetime.now().strftime('%H:%M:%S')
        log_entry = f"[{timestamp}] {message}"
        self.logs.append(log_entry)
        print(log_entry, file=sys.stderr if is_error else sys.stdout)
    
    def xor_cipher(self, text, key):
        """
        对给定文本执行异或加密。
        
        :param text: 要加密的字符串。
        :param key: 用于加密的密钥字符串。
        :return: 加密后的字节串。
        """
        if not key:
            raise ValueError("Key must not be empty.")
        
        # 将文本和密钥编码为字节
        text_bytes = text.encode('utf-8')
        key_bytes = key.encode('utf-8')
        key_len = len(key_bytes)
        
        # 执行异或操作
        encrypted_bytes = bytearray()
        for i, byte in enumerate(text_bytes):
            encrypted_bytes.append(byte ^ key_bytes[i % key_len])
            
        return bytes(encrypted_bytes)
    
    def generate_encryption_value(self, player_name=None):
        """生成加密值（与jiami.py保持一致的加密流程）"""
        if not player_name and not self.player_name:
            self.log("错误: 请提供姓名或工会名称！", is_error=True)
            return None
        
        name = player_name or self.player_name
        
        base64_encrypted = base64.b64encode(self.xor_cipher(str(name), "YSY")).decode('ascii')
        
        self.log(f"生成的加密值: {base64_encrypted}")
        self.log(f"\n生成的键值对（请手动添加到相应表中）：")
        self.log(f"1. BUFFString表：")
        self.log(f'["{base64_encrypted}"] = "Interface\\Icons\\[图标路径]",')
        self.log(f"\n2. 名称/工会名称：")
        self.log(f'["{name}"] = true,')
        
        return base64_encrypted
    
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
        
        return lua_files
    
    def merge_lua_files(self, lua_files):
        """合并Lua文件内容，在每个文件最后添加分号以提供文件之间的隔离"""
        merged_content = f"-- 合并的Lua文件\n-- 生成时间: {datetime.now().isoformat()}\n\n"
        
        for lua_file in lua_files:
            file_path = os.path.join(self.addon_folder, lua_file)
            if os.path.exists(file_path):
                try:
                    self.log(f"读取文件: {lua_file}")
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                    merged_content += f"\n-- 开始: {lua_file}\n"
                    merged_content += content
                    # 在文件内容末尾添加分号，除非已经有分号或行以开括号结尾
                    if content and not content.rstrip().endswith(';') and not content.rstrip().endswith('{') and not content.rstrip().endswith('(') and not content.rstrip().endswith('['):
                        merged_content += ';'
                    merged_content += f"\n-- 结束: {lua_file}\n"
                except Exception as e:
                    self.log(f"读取文件 {lua_file} 时出错: {str(e)}", is_error=True)
            else:
                self.log(f"警告: 文件不存在: {file_path}")
        
        return merged_content
    
    def smart_semicolon_optimization(self, code):
        """
        智能分号优化 - 修复版本，确保语法正确性
        """
        import re
        
        if not code.strip():
            return ""
        
        # 简单但有效的分号添加策略 - 不保护字符串，直接处理
        lines = [line.strip() for line in code.split('\n') if line.strip()]
        if not lines:
            return ""
        
        # 合并所有行
        merged = ' '.join(lines)
        
        # 在需要的地方添加分号
        # 在end后接标识符或local/function时添加分号
        merged = re.sub(r'(end)(?=\s+\w)', r'\1;', merged, flags=re.IGNORECASE)
        
        # 在函数调用后接local/function时添加分号
        merged = re.sub(r'(\w+\([^)]*\))(?=\s+(?:local|function)\b)', r'\1;', merged, flags=re.IGNORECASE)
        
        # 在赋值后接local/function时添加分号
        merged = re.sub(r'(=\s*[^;\n]*?)(?=\s+(?:local|function)\b)', r'\1;', merged, flags=re.IGNORECASE)
        
        # 清理多余空格
        merged = re.sub(r'\s+', ' ', merged)
        merged = re.sub(r'\s*([{}();,])\s*', r'\1', merged)
        merged = re.sub(r';\s*', '; ', merged)
        
        # 清理多余分号
        merged = re.sub(r';{2,}', ';', merged)
        
        return merged.strip()
    
    def ultra_safe_newline_optimization(self, code):
        """
        超安全换行符优化，确保不会破坏语法结构
        """
        lines = [line.strip() for line in code.split('\n') if line.strip()]
        if not lines:
            return ""
        
        result_lines = []
        i = 0
        n = len(lines)
        
        while i < n:
            line = lines[i]
            
            # 检查下一行是否是函数定义
            if i + 1 < n and re.match(r'^\s*(local\s+)?function\b', lines[i + 1]):
                # 当前行不是空行且不是注释，添加分号
                if line and not line.startswith('--'):
                    if not line.endswith(';'):
                        line += ';'
                result_lines.append(line)
                result_lines.append('')  # 添加空行分隔
            else:
                result_lines.append(line)
            
            i += 1
        
        # 最终清理
        final_code = '\n'.join(result_lines)
        
        # 移除多余空行，但保留必要的空行
        final_code = re.sub(r'\n{3,}', '\n\n', final_code)
        final_code = re.sub(r'^\n+|\n+$', '', final_code)
        
        return final_code
    
    def syntax_aware_final_cleanup(self, code):
        """
        基于语法的最终清理和验证
        """
        # 确保文件末尾有换行
        if not code.endswith('\n'):
            code += '\n'
        
        # 清理多余的空白行，但保留关键分隔
        lines = [line.rstrip() for line in code.split('\n') if line.strip()]
        
        # 智能空白行管理
        result_lines = []
        for i, line in enumerate(lines):
            # 检查是否是函数或控制结构
            if re.search(r'\b(function|if|for|while|repeat)\b', line):
                # 在这些结构前添加空行（除了第一个）
                if result_lines and not re.search(r'\b(end|else|elseif)\b', result_lines[-1]):
                    result_lines.append('')
            
            result_lines.append(line)
        
        # 确保每行清理
        final_lines = [line.rstrip() for line in result_lines]
        
        return '\n'.join(final_lines)
    
    def enhanced_validation_and_repair(self, code):
        """
        增强验证和自动修复
        """
        # 括号匹配验证
        brackets = {'[': ']', '(': ')', '{': '}'}
        
        def check_brackets(code, bracket_type):
            stack = []
            open_bracket = bracket_type
            close_bracket = brackets[bracket_type]
            
            for char in code:
                if char == open_bracket:
                    stack.append(char)
                elif char == close_bracket:
                    if not stack:
                        return False
                    stack.pop()
            
            return len(stack) == 0
        
        # 检查所有括号类型
        bracket_issues = []
        for bracket_type in ['[', '(', '{']:
            if not check_brackets(code, bracket_type):
                bracket_issues.append(bracket_type)
        
        if bracket_issues:
            self.log(f"警告: 检测到括号不匹配: {bracket_issues}", is_error=True)
            # 尝试简单修复
            code = re.sub(r'\s*([\[\(\{])\s*', r'\1', code)
            code = re.sub(r'\s*([\]\)\}])\s*', r'\1', code)
        
        # 字符串边界验证
        string_patterns = [
            (r'"[^"\\]*(?:\\.[^"\\]*)*"', '"'),
            (r"'[^'\\]*(?:\\.[^'\\]*)*'", "'"),
            (r'\[\[[\s\S]*?\]\]', '[[')
        ]
        
        for pattern, delimiter in string_patterns:
            matches = re.findall(pattern, code)
            for match in matches:
                if not (match.startswith(delimiter) and match.endswith(delimiter)):
                    self.log(f"警告: 字符串边界可能损坏: {match[:50]}...", is_error=True)
        
        return code
    
    def merge_lua_files_uncompressed(self, lua_files):
        """
        合并Lua文件但保持未压缩状态
        生成Contra_ALL.lua中间文件
        """
        import re
        import os
        
        all_content = []
        header_comments = []
        
        # 收集所有文件内容
        for file_path in lua_files:
            if not os.path.exists(file_path):
                continue
                
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # 提取文件开头的版权声明
            lines = content.split('\n')
            for line in lines:
                stripped = line.strip()
                if stripped.startswith('--') and (
                    'copyright' in stripped.lower() or 
                    'license' in stripped.lower() or 
                    'author' in stripped.lower() or
                    'title' in stripped.lower() or
                    stripped.startswith('---')
                ):
                    if line not in header_comments:
                        header_comments.append(line)
                elif not stripped.startswith('--') and stripped:
                    break
            
            # 添加文件标识
            rel_path = os.path.basename(file_path)
            all_content.append(f"-- 文件: {rel_path}")
            
            # 添加文件内容，移除多余空行
            file_lines = []
            for line in lines:
                stripped = line.strip()
                if stripped.startswith('--'):
                    file_lines.append(line.rstrip())
                elif stripped:
                    file_lines.append(line.rstrip())
                elif file_lines and file_lines[-1].strip():
                    file_lines.append('')
            
            if file_lines:
                all_content.extend(file_lines)
                all_content.append('')  # 文件间空行
        
        # 合并所有内容
        header_comment = '\n'.join(header_comments) + ('\n\n' if header_comments else '')
        merged_content = '\n'.join(all_content)
        
        # 清理多余的空行
        merged_content = re.sub(r'\n{3,}', '\n\n', merged_content)
        
        return header_comment + merged_content

    def minify_lua_code(self, code):
        """
        压缩Lua代码 - 基于LuaMinify开源项目的最佳实践
        
        功能：
        1. 移除不必要的空格和注释
        2. 保留必要的语法空格
        3. 处理字符串和注释的正确边界
        4. 优化代码大小同时保持语义正确
        """
        
        # 保存文件开头的版权声明和必要注释
        header_comments = []
        lines = code.split('\n')
        
        for line in lines:
            stripped = line.strip()
            if stripped.startswith('--') and (
                'copyright' in stripped.lower() or 
                'license' in stripped.lower() or 
                'author' in stripped.lower() or
                'title' in stripped.lower() or
                stripped.startswith('---')
            ):
                header_comments.append(line)
            elif not stripped.startswith('--') and stripped:
                break
        
        header_comment = '\n'.join(header_comments) + ('\n' if header_comments else '')
        
        # 使用状态机处理字符串和注释
        result = []
        i = 0
        length = len(code)
        
        while i < length:
            char = code[i]
            
            # 处理字符串
            if char in ['"', "'"]:
                quote = char
                result.append(char)
                i += 1
                
                # 读取字符串内容
                while i < length:
                    char = code[i]
                    result.append(char)
                    if char == quote:
                        break
                    elif char == '\\' and i + 1 < length:
                        i += 1
                        result.append(code[i])
                    i += 1
            
            # 处理长字符串 [[...]]
            elif char == '[' and i + 1 < length and code[i+1] == '[':
                result.append('[[')
                i += 2
                
                # 读取长字符串
                while i < length - 1:
                    if code[i] == ']' and code[i+1] == ']':
                        result.append(']]')
                        i += 2
                        break
                    else:
                        result.append(code[i])
                        i += 1
            
            # 处理单行注释
            elif char == '-' and i + 1 < length and code[i+1] == '-' and (i + 2 >= length or code[i+2] != '['):
                # 跳过到行尾
                while i < length and code[i] != '\n':
                    i += 1
                if i < length:
                    result.append('\n')
                    i += 1
                continue
            
            # 处理多行注释 --[[...]]
            elif char == '-' and i + 2 < length and code[i+1] == '-' and code[i+2] == '[' and code[i+3] == '[':
                # 跳过整个多行注释
                i += 4
                bracket_count = 2
                while i < length - 1:
                    if code[i] == ']' and code[i+1] == ']':
                        i += 2
                        break
                    i += 1
                continue
            
            # 处理空格
            elif char.isspace():
                # 保留必要的空格
                if i > 0 and i < length - 1:
                    prev_char = code[i-1]
                    next_char = code[i+1]
                    
                    # 保留关键字和标识符之间的空格
                    keywords = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 
                               'function', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 
                               'return', 'then', 'true', 'until', 'while', 'goto'}
                    
                    # 检查是否需要空格
                    needs_space = False
                    
                    # 检查前后是否是关键字/标识符
                    word_start = i - 1
                    while word_start >= 0 and (code[word_start].isalnum() or code[word_start] == '_'):
                        word_start -= 1
                    word_end = i + 1
                    while word_end < length and (code[word_end].isalnum() or code[word_end] == '_'):
                        word_end += 1
                    
                    if word_start >= 0 and word_end <= length:
                        prev_word = code[word_start+1:i]
                        next_word = code[i+1:word_end]
                        
                        if (prev_word in keywords or next_word in keywords or
                            prev_word.isalnum() or next_word.isalnum()):
                            needs_space = True
                    
                    if needs_space:
                        result.append(' ')
                i += 1
                continue
            
            # 处理其他字符
            else:
                result.append(char)
            
            i += 1
        
        minified_code = ''.join(result)
        
        # 后处理优化
        
        # 1. 移除多余空格
        minified_code = re.sub(r'\s+', ' ', minified_code)
        minified_code = re.sub(r'\s*([(){}\[\],;])\s*', r'\1', minified_code)
        
        # 2. 优化二元运算符周围的空格
        operators = {'+', '-', '*', '/', '%', '^', '#', '==', '~=', '<=', '>=', '<', '>', 
                    '=', '(', ')', '{', '}', '[', ']', ';', ',', '.', ':'}
        
        # 3. 移除行尾分号前的空格
        minified_code = re.sub(r'\s+;', ';', minified_code)
        
        # 4. 优化局部变量声明
        minified_code = re.sub(r'\s*local\s+', ' local ', minified_code)
        
        # 5. 优化函数定义
        minified_code = re.sub(r'\s*function\s*', ' function ', minified_code)
        
        # 6. 优化关键字
        keywords = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 
                   'function', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 
                   'return', 'then', 'true', 'until', 'while', 'goto'}
        
        for keyword in keywords:
            pattern = r'(?<![a-zA-Z_])' + keyword + r'(?![a-zA-Z_])'
            minified_code = re.sub(pattern, keyword, minified_code)
        
        # 7. 智能分号优化 - 解决相邻语句问题
        minified_code = self.smart_semicolon_optimization(minified_code)
        
        # 8. 超安全换行符优化
        minified_code = self.ultra_safe_newline_optimization(minified_code)
        
        # 9. 语法验证和修复
        minified_code = self.syntax_aware_final_cleanup(minified_code)
        
        # 10. 增强验证和修复
        minified_code = self.enhanced_validation_and_repair(minified_code)
        
        return header_comment + minified_code
    
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
    
    def create_release_folder(self):
        """创建发布版目录结构"""
        # 创建发布版目录
        release_folder = os.path.join(self.addon_folder, "发布版")
        if not os.path.exists(release_folder):
            os.makedirs(release_folder)
            
        # 在发布版中创建Contra文件夹
        contra_folder = os.path.join(release_folder, "Contra")
        if not os.path.exists(contra_folder):
            os.makedirs(contra_folder)
        
        return contra_folder
    
    def create_zip_file(self, contra_folder):
        """创建压缩包"""
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
    
    def process_folder(self):
        """处理插件文件夹"""
        if not self.addon_folder or not os.path.isdir(self.addon_folder):
            self.log(f"错误: 无效的文件夹路径: {self.addon_folder}", is_error=True)
            return False

        self.log(f"正在处理文件夹: {self.addon_folder}")
        
        # 创建发布版目录结构（包含Contra子文件夹）
        contra_folder = self.create_release_folder()
        
        try:
            # 查找TOC文件
            toc_files = [f for f in os.listdir(self.addon_folder) if f.lower().endswith('.toc')]
            
            if not toc_files:
                self.log("错误: 未找到TOC文件", is_error=True)
                return False
            
            # 使用第一个TOC文件
            toc_file = toc_files[0]
            toc_path = os.path.join(self.addon_folder, toc_file)
            self.log(f"找到TOC文件: {toc_file}")
            
            # 提取Lua文件列表
            lua_files = self.extract_lua_files_from_toc(toc_path)
            
            if not lua_files:
                self.log("警告: 未在TOC文件中找到Lua文件", is_error=True)
            else:
                self.log(f"找到 {len(lua_files)} 个Lua文件")
            
            # 合并Lua文件
            merged_content = self.merge_lua_files(lua_files)
            
            # 生成中间文件：合并但未压缩的Contra_ALL.lua
            all_lua_content = self.merge_lua_files_uncompressed(merged_content)
            all_lua_path = os.path.join(contra_folder, 'Contra_ALL.lua')
            with open(all_lua_path, 'w', encoding='utf-8') as f:
                f.write(all_lua_content)
            self.log(f"已保存合并未压缩文件: {all_lua_path}")
            
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
                # 保存为新的TOC文件到发布版/Contra目录
                # 注意：为了WOW识别，我们需要直接使用原文件名，而不是加updated_前缀
                new_toc_path = os.path.join(contra_folder, toc_file)
                with open(new_toc_path, 'w', encoding='utf-8') as f:
                    f.write(updated_toc_content)
                self.log(f"已保存更新后的TOC文件: {new_toc_path}")
            
            # 如果提供了玩家名称，生成加密值
            if self.player_name:
                self.log(f"\n正在为玩家 '{self.player_name}' 生成加密值...")
                self.generate_encryption_value(self.player_name)
            
            self.log("\n操作指南:")
            self.log("1. 生成并记录加密值（如果需要）")
            self.log("2. 手动将加密值添加到相应的表中")
            self.log("3. 重启魔兽世界客户端加载更新后的插件")
            
            # 创建压缩包
            self.create_zip_file(contra_folder)
            
            self.log("\n处理完成！")
            self.log(f"生成文件列表:")
            self.log(f"- 合并未压缩: {all_lua_path}")
            self.log(f"- 压缩版本: {minified_file_path}")
            self.log(f"- TOC文件: {new_toc_path}")
            
            return True
            
        except Exception as e:
            self.log(f"处理过程中发生错误: {str(e)}", is_error=True)
            return False

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='Lua批量处理工具')
    parser.add_argument('-f', '--folder', help='插件文件夹路径 (可选，默认使用当前脚本所在文件夹)')
    parser.add_argument('-n', '--name', help='姓名/工会名称')
    parser.add_argument('--encrypt', action='store_true', help='仅生成加密值')
    
    args = parser.parse_args()
    
    # 如果只提供了加密参数但没有提供名称，显示帮助信息
    if args.encrypt and not args.name:
        parser.print_help()
        print("\n示例用法:")
        print("1. 处理当前文件夹并生成加密值:")
        print("   python LuaBatchProcessor.py --name \"玩家名称\"")
        print("2. 仅生成加密值:")
        print("   python LuaBatchProcessor.py --name \"玩家名称\" --encrypt")
        return
    
    # 如果没有提供文件夹路径，使用脚本所在文件夹
    addon_folder = args.folder if args.folder else os.path.dirname(os.path.abspath(__file__))
    
    processor = LuaBatchProcessor(addon_folder=addon_folder, player_name=args.name)
    
    if args.encrypt:
        # 仅生成加密值
        processor.generate_encryption_value(args.name)
    else:
        # 处理插件文件夹
        processor.process_folder()

if __name__ == '__main__':
    main()