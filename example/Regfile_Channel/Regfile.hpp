

Regfile::Regfile (const char *name) :
        sc_prim_channel(name)
{
}


void Regfile::read(int &out, int address) {
    if(address < 32){
        out = regs_array.at(address);
    }
    return;
}

void Regfile::write(const int &val, int address) {
    if(address > 0 && address < 32){
        regs_array.at(address) = val;
    }
    return;
}

