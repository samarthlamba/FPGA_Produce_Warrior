module srLatch(q, s, r, enable);
    input s, r, enable;
    output q;

    wire topNorGate, bottomNorGate, andR, andS;

    and andRGate(andR, r, enable);

    and andSGate(andS, s, enable);
    nor topNor(topNorGate, andR, bottomNorGate);

    nor bottomNor(bottomNorGate, andS, topNorGate);

    assign q = topNorGate;
//https://www.google.com/search?q=sr+nor+latch&safe=active&rlz=1C1CHBF_enUS916US917&sxsrf=ALeKk02Yzz7tBE2474A9myItc1GWjFRL6A:1615145174078&source=lnms&tbm=isch&sa=X&ved=2ahUKEwj00vHS9J7vAhXxQd8KHU7qAakQ_AUoAnoECB8QBA&biw=1920&bih=969#imgrc=k8ZdRRvvLBD4fM
endmodule