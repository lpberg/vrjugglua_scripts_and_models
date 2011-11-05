f = open("C:\Users\lpberg\Desktop\pyin.txt",'r')
out = open("C:\Users\lpberg\Desktop\PYoutLua.lua",'w')
nodes = []
edges = []
#read in file
for line in f.readlines():
    splitLine = line.split()
    if splitLine[0] == "node":
        nodes.insert(int(splitLine[1]),splitLine[2:5])
    elif splitLine[0] == "edge":
        edges.append(splitLine[1:3])
print("Readin Completed. Creating Output for Lua")
#write out to file
out.write("N = {}\n")
for i in range(len(nodes)):
    out.write("N["+str(i)+"] = {"+str(nodes[i][0])+","+str(nodes[i][1])+","+str(nodes[i][2])+"}\n")
out.write("E = {}\n")
for e in range(len(edges)):
    out.write("E["+str(e)+"] = {"+str(edges[e][0])+","+str(edges[e][1])+"}\n")
out.write("G = {N,E}")
f.close()
out.close()
