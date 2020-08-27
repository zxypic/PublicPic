import streamlit as st
import pandas as pd
import numpy as np
from pathlib import Path
import time

from frame.frame_img import frame_img

def run_images():
    latest_iteration = st.empty()
    bar = st.progress(0)
    for i in range(100):
        # Update the progress bar with each iteration.
        latest_iteration.text(f'Iteration {i+1}')
        bar.progress(i + 1)
        time.sleep(0.1)


df = pd.DataFrame(np.random.randn(50, 20),
                  columns=('col %d' % i for i in range(20)))
option = st.sidebar.selectbox('Which function do you need best ?',
                              ["请选择", "图片切割", "获取fps", "流畅度计算"])
if option == '请选择': option = ""


@st.cache(persist=True)
def get_data():
    uploaded_file = st.file_uploader("Choose a MP4 file", type="mp4")
    if uploaded_file:
        st.video(uploaded_file)

    
video_file = st.text_input("待处理视频文件路径：", '/Users/xxxx/Downloads/lcd_tabqh.mp4')
if Path(video_file).exists():
    st.write('已找到待处理文件: ', video_file)  # is_file
    xnder = st.empty()
    xnder.warning('请在左侧选择功能后，点击运行')
    if option != "":
        xnder.subheader(f'You selected : {option}')
        mfram = frame_img(video_file)
        if option == "图片切割" and st.button('运行'):
            with st.spinner('Wait for it...'):
                time.sleep(5)
                st.success('Done!')
        elif option == "获取fps" and st.button('运行'):
            with st.spinner('FPS 获取中 ...'):
                fps = mfram.get_fps()  # 获取帧率
                time.sleep(1)
                st.success(f"获取完成！CAP_PROP_FPS : {fps}")
        elif option == "流畅度计算":
            btn = st.empty()
            xndery = st.empty()
            _frame = st.empty()
            _bar = st.empty()
            xndery.warning('在下面👇输入框中输入【起始帧&结束帧】列（支持从excle直接复制）')
            _data = st.empty()
            txt = _data.text_area('待处理的数据列 (格式：一组数据为一行，起始帧与结束帧用tab分割，如下示例)','''51\t73\n85\t94\n146\t209''')
            if txt!='51\t73\n85\t94\n146\t209':
                xndery.text("")
                txt = txt.split('\n')
                sframe = [i.split('\t')[0] for i in txt]
                eframe = [i.split('\t')[1] for i in txt]
                smrng = ['None' for i in range(len(txt))]
                mark = ['' for i in range(len(txt))]
                # st.number_input(st.text_area('uuuu'))
                st.markdown('**Get To be _process_ data :**')
                area = st.empty()
                area.table({'开始帧': sframe, '结束帧': eframe, '流畅度': smrng, ' ': mark, '  ': mark})
                if btn.button('开始计算'):
                    _data.text('')
                    mfram = frame_img(video_file)
                    se_frame = [i.split('\t') for i in txt]
                    bar = _bar.progress(0)
                    for i in range(len(txt)):
                        _frame.text(f'当前处理第【{i+1}】组\tframe : {se_frame[i][0]}->{se_frame[i][1]}')
                        smrng[i] = "计算中···"
                        area.table({'开始帧': sframe, '结束帧': eframe, '流畅度': smrng, ' ': mark, '  ': mark})
                        fps = mfram.fram_imwrite(int(se_frame[i][0]),int(se_frame[i][1]))  
                        bar.progress(round((i+1)/(len(txt))*100))
                        smrng[i] = fps
                        area.table({'开始帧': sframe, '结束帧': eframe, '流畅度': smrng, ' ': mark, '  ': mark})
                    xndery.success("流畅度计算完成！")
                    st.balloons()
else:
    st.error("请输入正确的视频文件路径")


def get_user_name():
    return 'John'


# ------------------------------------------------
# with st.echo():
#     # Everything inside this block will be both printed to the screen
#     # and executed.
#     st.header('请在左侧选择功能后，点击运行')
#     st.warning('请在左侧选择功能后，点击运行')
#     st.info("获取一下fps")

#     def get_punctuation():
#         return '!!!'

#     greeting = "Hi there, "
#     value = get_user_name()
#     punctuation = get_punctuation()

#     st.write(greeting, value, punctuation)
                # number = st.number_input('Insert a number')
                # st.write('The current number is ', number)
                # st.dataframe(df)  # Same as st.write(df)
                # st.table(df)  # 显示静态数据表
                # uploaded_file = st.file_uploader("Choose a CSV file", type="mp4")
                # if uploaded_file is not None:
                #     reader = skvideo.io.FFmpegReader(uploaded_file)
                #     for frame in reader.nextFrame():
                #         st.info("ing...")
                #     data = pd.read_csv(uploaded_file)
                #     st.write(data)
# # And now we're back to _not_ printing to the screen
# foo = 'bar'
# st.write('Done!')
