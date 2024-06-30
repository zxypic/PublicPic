
import requests
from pathlib import Path
import re
import envoy
import arrow

def get_tsname(testtc):
	tsid = re.search(r"(\d{6})\.",testtc).group(0)
	indexid = re.search(r"\=(\d+){1}",testtc).group()
	indexid = re.search(r"\d+", indexid).group().zfill(3)
	new_ts = "{}index_{}.ts".format(tsid, indexid)
	return new_ts #, re.sub(r"\=","_",new_ts)

def download(url, name, timeout, retry):
	try:
		if not name.parent.is_dir():
			name.parent.mkdir(exist_ok=True, parents=True)
		ret = requests.get(url, timeout=timeout)
		with open(name, 'wb') as f:
			f.write(ret.content)
			f.flush()
		print("download {} finished {:.3f} KB".format(name, name.stat().st_size/2014 ) )	# /float(1024)
	except requests.exceptions.RequestException as e:
		print(e)
		if retry > 0:
			print("Download retry")
			download(url, name, timeout, retry - 1)

def process_tsurl(txts_url):
	t = arrow.now()
	t_flg = t.format("HH_mm_ss")
	root = Path('.',"tempTc",t_flg)
	print("path : ",root)
	for ts_url in txts_url:
		ts_name = get_tsname(ts_url)
		print(ts_name)
		download(ts_url, Path(root, ts_name), timeout=60, retry=3)
	import platform
	systemInfo = re.compile(platform.system(), re.IGNORECASE)
	if systemInfo.search('Windows'):
		cmd = 'copy /b ' + Path(root, "*.ts") + ' ' + Path(root.parent, "TS_{}.mp4".format(t_flg))
	tscat = 'cat {} > {}'.format(Path(root, "*.ts").resolve(), Path(root.parent, "TS_{}.mp4".format(t_flg)).resolve()) 
	print("cat marge: ",tscat)
	import os
	os.system(tscat)
	print("marge result : {:.3f} KB".format(Path(root.parent, "TS_{}.mp4".format(t_flg)).stat().st_size/1024))
	# tc = envoy.run(str(tscat))
	# print(tc.status_code, tc.std_err, tc.std_out)


with open("./local/ts_url.txt") as f:
	ts_urls = f.readlines()
	process_tsurl(ts_urls)


'''使用说明
将有效的ts分片url链接存储在 ts_url.txt 文件中 
运行本脚本，即可生成并合并为mp4文件
'''