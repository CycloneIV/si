





def wrr_init(pri2,pri1,pri0):
	pri_ori_list = [pri2,pri1,pri0]
	return pri_ori_list






def wrr_cal(pri_list,pri_ori_list,psel_3bit):
	max_pri = pri_list[2]
	index = 2
	max_index = 2
	mus_sum = 0
	pri_after = pri_list

#	print('psel_3bit = %s' %psel_3bit)
#	print('ssssssss %d' %len(psel_3bit))
#	print(type(psel_3bit))
	for x in reversed(psel_3bit):
#		print('ssssssss %d' %len(psel_3bit))
#		print('x = %s' %x)
		if(x == '1'):
			mus_sum = mus_sum + pri_ori_list[index]
			pri_after[index] = pri_list[index] + pri_ori_list[index]
			if (max_pri < pri_list[index]):
				max_pri = pri_list[index]
				max_index = index
		index = index - 1
		print('maxindex = %d' % max_index)
	pri_after[max_index] = pri_after[max_index] - mus_sum
	

	if psel_3bit == '000':
		grant_fnl = '000'
	elif max_index == 2:
		grant_fnl = '001'
	elif max_index == 1:
		grant_fnl = '010'
	elif max_index == 0:
		grant_fnl = '100'
	else:
		grant_fnl = '000'

	return pri_after,grant_fnl


#print('**************************************')
#pri_ori_list = wrr_init(1,3,6)
#print('ori_list: %s' %pri_ori_list)
#pri_after = pri_ori_list.copy()
#psel = ['1','1','1']
#pri_after,grant_fnl = wrr_cal(pri_after,pri_ori_list,psel)
#print(pri_after)
#print(grant_fnl)
#print(pri_ori_list)
#print('**************************************')
#pri_after,grant_fnl = wrr_cal(pri_after,pri_ori_list,psel)
#print(pri_after)
#print(grant_fnl)
#print(pri_ori_list)
#print('**************************************')
#pri_after,grant_fnl = wrr_cal(pri_after,pri_ori_list,psel)
#print(pri_after)
#print(grant_fnl)
#print(pri_ori_list)
#print('**************************************')



pri_ori_list = wrr_init(1,3,6)
pri_after = pri_ori_list.copy()

with open('a.txt','r') as f:
	line_all = f.readlines()

print(len(line_all))
for line in line_all:
	line.strip()
	line_tmp = list(line)
	line_tmp.pop()
	pri_after,grant_fnl = wrr_cal(pri_after,pri_ori_list,line_tmp)
	print('pri_after = %s' %pri_after)
	print('grant_fnl = %s' %grant_fnl)

f.close() 	 