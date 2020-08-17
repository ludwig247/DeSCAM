

Regfile::Regfile (const char *name) :
        sc_prim_channel(name)
{
}


void Regfile::read(std::array<int,32> &out) {
    out = regs;
    return;
}

void Regfile::write(const int &val, int address) {
    assert(address < 32);
    write_dummy_notify.notify();
    wait(dummy_write_notify);
    for(int i=0; i<32; i++) {
        regs.at(i) = address == i ? val : regs.at(i);
    }
    return;
}
void Regfile::dummyFunc(){
    while(true){
        dummy_write_notify.notify();
        wait(write_dummy_notify);
    }
}

