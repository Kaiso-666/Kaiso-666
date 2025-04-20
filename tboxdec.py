def tbox(txt):
    l1=len(txt)*"-"+4*"-"+"\n"
    l2=f"| {txt} |"+"\n"
    l3=l1.replace("\n", "")
    boxt=l1+l2+l3
    return boxt