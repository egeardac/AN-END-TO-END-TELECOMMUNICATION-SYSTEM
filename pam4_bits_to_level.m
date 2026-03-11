function level = pam4_bits_to_level(b1, b2, d)
    a = d/2;
    if b1==0 && b2==0
        level =  3*a;
    elseif b1==0 && b2==1
        level =  1*a;
    elseif b1==1 && b2==1
        level = -1*a;
    else
        level = -3*a;
    end
end