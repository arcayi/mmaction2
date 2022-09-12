LABELS =$1
# DATASET=$2

for DATASET in "kinetics400" "kinetics600" "kinetics700"
do
    echo $DATASET

    echo "1, 从Kinetics 数据集官网下载标注文件并进行预处理："
    bash download_annotations.sh ${DATASET}

    echo "  MMAction2 提供了另一种方式以获取初始版本标注作为参考"
    bash download_backup_annotations.sh ${DATASET}

    echo "2, 准备视频"
    bash download_videos.sh ${DATASET} $LABELS

    echo "  替换掉类名中的空格"
    bash rename_classnames.sh ${DATASET}

    echo "  将原始视频缩放至更小的分辨率（利用稠密编码）"
    python ../resize_videos.py ../../../data/${DATASET}/videos_train/ ../../../data/${DATASET}/videos_train_256p_dense_cache --dense --level 2

    echo "3. 提取 RGB 帧和光流。如果用户仅使用 video loader，则可以跳过本步。"

    echo "4. 生成文件列表"
    bash generate_videos_filelist.sh ${DATASET}

done
