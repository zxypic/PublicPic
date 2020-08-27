
import streamlit as st
import torch
y = torch.rand(5, 3)
print(y)
import pandas as pd

# Reuse this data across runs!
read_and_cache_csv = st.cache(pd.read_csv)

BUCKET = "https://streamlit-self-driving.s3-us-west-2.amazonaws.com/"
data = read_and_cache_csv(BUCKET + "/works/git_auto/engine3.0/local/labels.csv.gz", nrows=1000)
desired_label = st.selectbox('Filter to:', ['car', 'truck'])
st.write(data[data.label == desired_label])

x = st.slider('xy')
# st.sidebar.add_rows("uuruuuwi")
# Adds a checkbox to the sidebar
add_selectbox = st.sidebar.checkbox(
    'How would you like to be contacted?',
    ('Email', 'Home phone', 'Mobile phone')
)

# Adds a slider to the sidebar
add_slider = st.sidebar.slider(
    'Select a range of values',
    0.0, 100.0, (25.0, 75.0)
)

# st.write(x, 'squared is', x * x, y)
