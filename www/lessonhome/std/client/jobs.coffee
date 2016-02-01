
funcs = ['signal','onSignal','solve','listen','server']

Std.jobs = {}
for f in funcs
  do (f)-> Std.jobs[f] = -> Feel.jobs[f].apply Feel.jobs,arguments
