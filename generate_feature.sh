#!/bin/bash

# Flutter Feature Generator Script
# Usage: ./generate_feature.sh <feature_name> <entity_name>
# Example: ./generate_feature.sh user_management user

# 检查参数数量是否为2个，如果不是则显示使用说明
if [ $# -ne 2 ]; then
    # 显示脚本使用方法，$0代表脚本名称
    echo "Usage: $0 <feature_name> <entity_name>"
    echo "Example: $0 user_management user"
    exit 1
fi

FEATURE_NAME=$1
ENTITY_NAME=$2

echo "🚀 Generating Flutter feature with BLoC pattern..."
echo "Feature: $FEATURE_NAME"
echo "Entity: $ENTITY_NAME"
echo ""

# Run the Dart generator
dart tools/generate_feature.dart "$FEATURE_NAME" "$ENTITY_NAME"

# 检查上一个命令（dart tools/generate_feature.dart）的退出状态码
# $? 表示上一个命令的退出状态码，0表示成功，非0表示失败
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Feature generation completed!"
    echo ""
else
    echo "❌ Feature generation failed!"
    exit 1
fi
