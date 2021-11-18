#!/usr/bin/env python
import subprocess
import re
from time import sleep
import psutil

def get_supervisord_jobs_metrics(jobs:dict):
    metrics = jobs
    for p in psutil.process_iter(['pid','cpu_percent','memory_percent']):
        if str(p.info["pid"]) in jobs.keys():
            metrics[str(p.info["pid"])]["cpu_usage"] = p.info["cpu_percent"]
            metrics[str(p.info["pid"])]["mem_usage"] = p.info["memory_percent"]
    return metrics

def update_supervisord_jobs():
    supervisord_jobs = subprocess.run(['sudo', '/usr/bin/supervisorctl','status all'], stdout = subprocess.PIPE)
    raw_output = supervisord_jobs.stdout.decode('UTF-8').splitlines()
    jobs = dict()
    for i in range(len(raw_output)):
        line = re.sub(' +',' ',raw_output[i])
        elems = line.split(maxsplit=4)
        if len(elems) == 5:
            elems[3] = elems[3].replace(",","")
            if elems[3].isdigit():
                if elems[0].find(":") != -1:
                    jobs[elems[3]] =  {
                            "group":elems[0].split(":")[0],
                            "name":elems[0].split(":")[1],
                        }
                else:
                    jobs[elems[3]] =  {
                            "name":elems[0].split(":")[0]
                        }
    return jobs

def dump_job_metrics(jobs:dict,metric):
    lines = []
    if metric in ["cpu_usage","mem_usage"]:
        for pid in jobs.keys():
            if "group" in jobs[pid]:
                lines.append(f'supervisord_job_{metric}{{group="{jobs[pid]["group"]}", name="{jobs[pid]["name"]}"}} {jobs[pid][metric]}\n')
            else:
                lines.append(f'supervisord_job_{metric}{{name="{jobs[pid]["name"]}"}} {jobs[pid][metric]}\n')
    return lines

while True:
    count = 0
    jobs = update_supervisord_jobs()
    while count < 6:
        metrics = get_supervisord_jobs_metrics(jobs)
        f = open('supervisor.prom','w')
        f.writelines(['# HELP supervisord_job_cpu_usage Percentage of cpu usage at the moment.\n','# TYPE supervisord_job_cpu_usage gauge\n'])
        f.writelines(dump_job_metrics(metrics,'cpu_usage'))
        f.writelines(['# HELP supervisord_job_mem_usage Percentage of mem usage at the moment.\n','# TYPE supervisord_job_mem_usage gauge\n'])
        f.writelines(dump_job_metrics(metrics,'mem_usage'))
        f.close()
        count = count + 1
        sleep(10)

