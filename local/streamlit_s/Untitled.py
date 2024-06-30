'''
@Author: 咸的
@Date: 2020-03-09 14:35:31
@LastEditTime: 2020-03-10 14:08:05
@Description: In User Settings Edit
'''

txt = '''120	132
261	294
416	429
541	555
680	692
784	799
926	939
1082	1096
1212	1224
1333	1344
1452	1466
1586	1598
1728	1743
1891	1905
2038	2050
2183	2196
2354	2367
2502	2515
2675	2687
2807	2818
2926	2939
3079	3107
3256	3269
3392	3406
3507	3521
3641	3652
3773	3787
3904	3919
4028	4040
4147	4160
4257	4269'''

txt = txt.split('\n')

stfr = [i.split('\t')[0] for i in txt ]
# print(stfr)
se_frame = [i.split('\t') for i in txt]
# print(se_frame)
for i in range(len(txt)):
    print(se_frame[i][0],se_frame[i][1], round((i+1)/(len(txt))*100))