main:
        addiu   $sp,$sp,-96
        sw      $fp,92($sp)
        sw      $23,88($sp)
        sw      $22,84($sp)
        sw      $21,80($sp)
        sw      $20,76($sp)
        sw      $19,72($sp)
        sw      $18,68($sp)
        sw      $17,64($sp)
        sw      $16,60($sp)
        move    $fp,$sp
        addi    $2,$zero,5                        # 0x5
        sw      $2,28($fp)
        addi    $2,$zero,10                 # 0xa
        sw      $2,32($fp)
        addi    $2,$zero,5                        # 0x5
        sw      $2,36($fp)
        addi    $2,$zero,2147418112                 # 0x7fff0000
        ori     $2,$2,0xffff
        sw      $2,8($fp)
        sw      $0,12($fp)
$L12:
        lw      $3,12($fp)
        lw      $2,28($fp)
        nop
        slt     $2,$2,$3
        bne     $2,$0,$L2
        nop

        move    $2,$sp
        move    $23,$2
        sb      $0,16($fp)
        lw      $20,32($fp)
        nop
        sw      $20,40($fp)
        move    $2,$20
        addiu   $2,$2,1
        move    $13,$2
        move    $12,$0
        srl     $2,$13,27
        sll     $4,$12,5
        or      $4,$2,$4
        sll     $5,$13,5
        move    $2,$20
        addiu   $2,$2,1
        sll     $11,$2,2
        lw      $10,12($fp)
        nop
        sw      $10,44($fp)
        move    $2,$20
        addiu   $2,$2,1
        move    $15,$2
        move    $14,$0
        move    $2,$10
        addiu   $2,$2,1
        move    $25,$2
        move    $24,$0
        mult    $14,$25
        mflo    $2
        nop
        nop
        mult    $24,$15
        mflo    $3
        addu    $21,$2,$3
        nop
        multu   $15,$25
        mflo    $3
        mfhi    $2
        addu    $21,$21,$2
        move    $2,$21
        srl     $21,$3,27
        sll     $6,$2,5
        or      $6,$21,$6
        sll     $7,$3,5
        move    $2,$20
        addiu   $2,$2,1
        move    $17,$2
        move    $16,$0
        move    $2,$10
        addiu   $2,$2,1
        move    $19,$2
        move    $18,$0
        mult    $16,$19
        mflo    $2
        nop
        nop
        mult    $18,$17
        mflo    $3
        addu    $21,$2,$3
        nop
        multu   $17,$19
        mflo    $3
        mfhi    $2
        addu    $21,$21,$2
        move    $2,$21
        srl     $21,$3,27
        sll     $8,$2,5
        or      $8,$21,$8
        sll     $9,$3,5
        move    $2,$20
        addiu   $3,$2,1
        move    $2,$10
        addiu   $2,$2,1
        mult    $3,$2
        mflo    $2
        sll     $2,$2,2
        addiu   $2,$2,3
        addiu   $2,$2,7
        srl     $2,$2,3
        sll     $2,$2,3
        subu    $sp,$sp,$2
        move    $2,$sp
        addiu   $2,$2,3
        srl     $2,$2,2
        sll     $2,$2,2
        sw      $2,48($fp)
        lw      $2,48($fp)
        nop
        move    $21,$2
$L6:
        addi    $2,$zero,-1                 # 0xffffffffffffffff
        beq     $10,$2,$L3
        nop

        move    $3,$21
        move    $2,$20
$L5:
        addi    $22,$zero,-1                  # 0xffffffffffffffff
        beq     $2,$22,$L4
        nop

        sw      $0,0($3)
        addiu   $3,$3,4
        addiu   $2,$2,-1
        b       $L5
        nop

$L4:
        move    $2,$20
        addiu   $2,$2,1
        sll     $2,$2,2
        addu    $21,$21,$2
        addiu   $10,$10,-1
        b       $L6
        nop

$L3:
        sw      $0,20($fp)
$L10:
        srl     $10,$11,2
        lw      $3,48($fp)
        lw      $2,12($fp)
        nop
        mult    $10,$2
        lw      $2,20($fp)
        mflo    $10
        addu    $2,$10,$2
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L7
        nop

        lw      $2,20($fp)
        nop
        addiu   $2,$2,1
        sw      $2,20($fp)
        addi    $2,$zero,1                        # 0x1
        sw      $2,24($fp)
$L9:
        lw      $3,24($fp)
        lw      $2,12($fp)
        nop
        slt     $2,$2,$3
        bne     $2,$0,$L10
        nop

        srl     $20,$11,2
        srl     $21,$11,2
        lw      $2,20($fp)
        nop
        addiu   $2,$2,-1
        lw      $3,48($fp)
        lw      $10,24($fp)
        nop
        mult    $21,$10
        mflo    $10
        addu    $2,$10,$2
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        srl     $22,$11,2
        lw      $2,24($fp)
        nop
        addiu   $21,$2,-1
        lw      $2,20($fp)
        nop
        addiu   $2,$2,-1
        lw      $10,48($fp)
        mult    $22,$21
        mflo    $21
        addu    $2,$21,$2
        sll     $2,$2,2
        addu    $2,$10,$2
        lw      $2,0($2)
        nop
        addu    $2,$3,$2
        addiu   $3,$2,1
        lw      $10,48($fp)
        lw      $2,24($fp)
        nop
        mult    $20,$2
        lw      $2,20($fp)
        mflo    $20
        addu    $2,$20,$2
        sll     $2,$2,2
        addu    $2,$10,$2
        sw      $3,0($2)
        srl     $10,$11,2
        lw      $3,48($fp)
        lw      $2,24($fp)
        nop
        mult    $10,$2
        lw      $2,20($fp)
        mflo    $10
        addu    $2,$10,$2
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $2,36($fp)
        nop
        slt     $2,$3,$2
        xori    $2,$2,0x1
        sb      $2,16($fp)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
        b       $L9
        nop

$L7:
        lw      $3,20($fp)
        lw      $2,12($fp)
        nop
        addu    $3,$3,$2
        lw      $2,8($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L11
        nop

        lw      $3,20($fp)
        lw      $2,12($fp)
        nop
        addu    $2,$3,$2
        sw      $2,8($fp)
$L11:
        move    $sp,$23
        lw      $2,12($fp)
        nop
        addiu   $2,$2,1
        sw      $2,12($fp)
        b       $L12
        nop

$L2:
        move    $2,$0
        move    $sp,$fp
        lw      $fp,92($sp)
        lw      $23,88($sp)
        lw      $22,84($sp)
        lw      $21,80($sp)
        lw      $20,76($sp)
        lw      $19,72($sp)
        lw      $18,68($sp)
        lw      $17,64($sp)
        lw      $16,60($sp)
        addiu   $sp,$sp,96
        nop