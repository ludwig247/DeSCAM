
# @author :	Dino Mehmedagić
# @name   : 	enc_i_j_low.s
# @purpose: 	Test for I-type jump with an attempt to eliminate power dependency on data

.globl _start
_start:
	#~~~~~~~~INST~~~~~~~~	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~NOTES~~~~~~~~~~~~~~~~~~~~~~~~~~~~       


	jalr x0,x0,4
	jalr x0,x0,8
	jalr x0,x0,12
	jalr x0,x0,16
	jalr x0,x0,20
	jalr x0,x0,24
	jalr x0,x0,28
	jalr x0,x0,32
	jalr x0,x0,36
	jalr x0,x0,40
	jalr x0,x0,44
	jalr x0,x0,48
	jalr x0,x0,52
	jalr x0,x0,56
	jalr x0,x0,60
	jalr x0,x0,64
	jalr x0,x0,68
	jalr x0,x0,72
	jalr x0,x0,76
	jalr x0,x0,80
	jalr x0,x0,84
	jalr x0,x0,88
	jalr x0,x0,92
	jalr x0,x0,96
	jalr x0,x0,100
	jalr x0,x0,104
	jalr x0,x0,108
	jalr x0,x0,112
	jalr x0,x0,116
	jalr x0,x0,120
	jalr x0,x0,124
	jalr x0,x0,128
	jalr x0,x0,132
	jalr x0,x0,136
	jalr x0,x0,140
	jalr x0,x0,144
	jalr x0,x0,148
	jalr x0,x0,152
	jalr x0,x0,156
	jalr x0,x0,160
	jalr x0,x0,164
	jalr x0,x0,168
	jalr x0,x0,172
	jalr x0,x0,176
	jalr x0,x0,180
	jalr x0,x0,184
	jalr x0,x0,188
	jalr x0,x0,192
	jalr x0,x0,196
	jalr x0,x0,200
	jalr x0,x0,204
	jalr x0,x0,208
	jalr x0,x0,212
	jalr x0,x0,216
	jalr x0,x0,220
	jalr x0,x0,224
	jalr x0,x0,228
	jalr x0,x0,232
	jalr x0,x0,236
	jalr x0,x0,240
	jalr x0,x0,244
	jalr x0,x0,248
	jalr x0,x0,252
	jalr x0,x0,256
	jalr x0,x0,260
	jalr x0,x0,264
	jalr x0,x0,268
	jalr x0,x0,272
	jalr x0,x0,276
	jalr x0,x0,280
	jalr x0,x0,284
	jalr x0,x0,288
	jalr x0,x0,292
	jalr x0,x0,296
	jalr x0,x0,300
	jalr x0,x0,304
	jalr x0,x0,308
	jalr x0,x0,312
	jalr x0,x0,316
	jalr x0,x0,320
	jalr x0,x0,324
	jalr x0,x0,328
	jalr x0,x0,332
	jalr x0,x0,336
	jalr x0,x0,340
	jalr x0,x0,344
	jalr x0,x0,348
	jalr x0,x0,352
	jalr x0,x0,356
	jalr x0,x0,360
	jalr x0,x0,364
	jalr x0,x0,368
	jalr x0,x0,372
	jalr x0,x0,376
	jalr x0,x0,380
	jalr x0,x0,384
	jalr x0,x0,388
	jalr x0,x0,392
	jalr x0,x0,396
	jalr x0,x0,400

	ebreak
