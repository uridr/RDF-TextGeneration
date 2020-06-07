import json

filepath = "../data/loss/"
filename = "fairseq_644"


lossLogs = []

with open(filepath+filename+".log") as f:
	line = f.readline()
	
	if line[0] == '{':
		lossLogs.append(line)
	
	while line:
		if line[0] == '{':
			lossLogs.append(line)

		line = f.readline()


json_d = []
with open(filepath+filename+"_loss.json", 'w') as file:
	for d in lossLogs:
		json_data = json.loads(d)
		json_d.append(json_data)

	json.dump(json_d, file, indent = 4)

