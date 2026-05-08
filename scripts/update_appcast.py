#!/usr/bin/env python3

"""
更新 Sparkle appcast.xml 文件
"""

import argparse
import xml.etree.ElementTree as ET
from datetime import datetime
import os

def update_appcast(version, build, size, signature, url, changelog=None):
    appcast_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'sparkle', 'appcast.xml')

    # 创建新的 item 元素
    item = ET.Element('item')

    # 版本标题
    title = ET.SubElement(item, 'title')
    title.text = f'Version {version}'

    # 发布日期
    pub_date = ET.SubElement(item, 'pubDate')
    pub_date.text = datetime.now().strftime('%Y-%m-%d')

    # Sparkle 版本信息
    sparkle_version = ET.SubElement(item, 'sparkle:version')
    sparkle_version.text = str(build)

    short_version = ET.SubElement(item, 'sparkle:shortVersionString')
    short_version.text = version

    # 系统要求
    min_sys = ET.SubElement(item, 'sparkle:minimumSystemVersion')
    min_sys.text = '14.0'

    # 描述（变更日志）
    if changelog:
        description = ET.SubElement(item, 'description')
        description.text = changelog

    # enclosure（下载链接）
    enclosure = ET.SubElement(item, 'enclosure')
    enclosure.set('url', url)
    enclosure.set('sparkle:edSignature', signature or '')
    enclosure.set('length', str(size))
    enclosure.set('type', 'application/octet-stream')

    # 读取现有 appcast
    try:
        tree = ET.parse(appcast_path)
        root = tree.getroot()
        channel = root.find('channel')

        # 移除旧版本（可选：保留历史版本）
        # 这里我们只保留最新版本
        for old_item in channel.findall('item'):
            channel.remove(old_item)

        # 添加新版本
        channel.insert(0, item)

    except FileNotFoundError:
        # 创建新的 appcast.xml
        root = ET.Element('rss')
        root.set('version', '2.0')
        root.set('xmlns:sparkle', 'http://www.andymatuschak.org/xml-namespaces/sparkle')
        root.set('xmlns:dc', 'http://purl.org/dc/elements/1.1/')

        channel = ET.SubElement(root, 'channel')

        title_elem = ET.SubElement(channel, 'title')
        title_elem.text = 'MewNotch Updates'

        link = ET.SubElement(channel, 'link')
        link.text = 'https://monuk7735.github.io/mew-notch/sparkle/appcast.xml'

        desc = ET.SubElement(channel, 'description')
        desc.text = 'Most recent changes with links to updates.'

        language = ET.SubElement(channel, 'language')
        language.text = 'en'

        channel.append(item)
        tree = ET.ElementTree(root)

    # 保存
    tree.write(appcast_path, encoding='utf-8', xml_declaration=True)
    print(f"appcast.xml 已更新: {appcast_path}")

def main():
    parser = argparse.ArgumentParser(description='更新 Sparkle appcast.xml')
    parser.add_argument('--version', required=True, help='版本号 (如 2.2.1)')
    parser.add_argument('--build', required=True, help='构建号 (如 221)')
    parser.add_argument('--size', required=True, type=int, help='文件大小 (bytes)')
    parser.add_argument('--signature', default='', help='Sparkle ED签名')
    parser.add_argument('--url', required=True, help='下载链接')
    parser.add_argument('--changelog', default='', help='变更日志 (HTML)')

    args = parser.parse_args()
    update_appcast(args.version, args.build, args.size, args.signature, args.url, args.changelog)

if __name__ == '__main__':
    main()