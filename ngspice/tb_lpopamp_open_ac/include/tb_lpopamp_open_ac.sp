* num: #num corner: #corner vdd: #vdd temp: #temp

**.subckt tb_lpopamp_open_ac
Xdut im_ ip out avdd avss en enb ibias lpopamp
v_avss GND avss xavss
v_avdd avdd avss dc {xavdd} ac {xavdd_ac} 
v_en en avss {xen*xavdd} 
v_enb enb avss {(1-xen)*xavdd} 
i_ibias avdd ibias {xen*xibias} 
c_l out cm 'xcl' m=1 
c_i im_ im 'xci' m=1 
l_f out im_ 'xlf' m=1 
v_cm cm avss {xcm} 
v_im im avss dc {xavdd/2} 
v_ip ip avss dc {xavdd/2} 
**** begin user architecture code


* Include SkyWater sky130 device models
.lib /usr/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice #corner
.param mc_mm_switch=0
.temp #temp




.option gmin=1e-12
.option rshunt=1e12
.control
  * differential input
  alter v_ip   ac=0
  alter v_im   ac=1
  alter v_avdd ac=0

  op
  ac dec 10 10m 10G

  * common-mode input
  alter v_ip   ac=1
  alter v_im   ac=1
  alter v_avdd ac=0

  ac dec 10 10m 10G

  * power supply
  alter v_ip   ac=0
  alter v_im   ac=0
  alter v_avdd ac=1

  ac dec 10 10m 10G

  let idd = op.i(v_avdd)
  let av = db(ac1.out)
  let ph = cphase(ac1.out)*180/(4*atan(1))
  let cmrr = db(ac1.out/ac2.out)
  let psrr = db(ac1.out/ac3.out)

  meas ac av0p1hz find av at=0.1
  meas ac gbw when av=0
  meas ac pm180 when ph=-180
  meas ac pm find ph at=gbw
  meas ac gm find av at=pm180

  meas ac cmrr0p1hz find cmrr at=0.1
  meas ac psrr0p1hz find psrr at=0.1

  plot av cmrr psrr
  plot ph
  print idd

  echo "gbw,pm,av0p1hz,cmrr0p1hz,psrr0p1hz,idd" > ./meas/tb_lpopamp_open_ac.meas#num
  echo "$&gbw,$&pm,$&av0p1hz,$&cmrr0p1hz,$&psrr0p1hz,$&idd" >> ./meas/tb_lpopamp_open_ac.meas#num

  wrdata ./data/tb_lpopamp_open_ac.dat#num av ph cmrr psrr

.endc




.param xavdd  = #vdd
.param xavss  = 0
.param xcm    = {#vdd/2}
.param xvin   = 0
.param xvout  = 0

.param xen =  1
.param xip =  0
.param xim =  1

.param xavdd_ac = 0
.param xvin_ac  = 1
.param xvout_ac = 0

.param xibias = 10u

.param xci    = 1T
.param xri    = 1T
.param xlf    = 1T
.param xrf    = 1f
.param xcl    = 30p
.param xrl    = 5k


**** end user architecture code
**.ends

* expanding   symbol:  lpopamp.sym # of pins=8
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/lpopamp.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/lpopamp.sch
.subckt lpopamp  im  ip  o  avdd  avss  en  enb  ibias
*.iopin avdd
*.iopin avss
*.iopin ip
*.iopin im
*.iopin o
*.iopin ibias
*.iopin en
*.iopin enb
xslice[1] im ip o avdd avss en enb bpa bpb bnb bna xp ypp ypm zpp zpm xn ynp ynm znp znm
+ lpopamp_slice
xslice[0] im ip o avdd avss en enb bpa bpb bnb bna xp ypp ypm zpp zpm xn ynp ynm znp znm
+ lpopamp_slice
ralias_ibias ibias bnb 1 m=1
XCp o zpm sky130_fd_pr__cap_mim_m3_1 W=90 L=60 MF=1 m=1
XCn o znm sky130_fd_pr__cap_mim_m3_1 W=90 L=60 MF=1 m=1
.ends


* expanding   symbol:  lpopamp_slice.sym # of pins=21
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/lpopamp_slice.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/lpopamp_slice.sch
.subckt lpopamp_slice  im  ip  o  avdd  avss  en  enb  bpa  bpb  bnb  bna  xp  ypp  ypm  zpp  zpm
+  xn  ynp  ynm  znp  znm
*.iopin avdd
*.iopin avss
*.iopin ip
*.iopin im
*.iopin o
*.iopin bpa
*.iopin bpb
*.iopin bnb
*.iopin bna
*.iopin ypp
*.iopin ypm
*.iopin zpm
*.iopin zpp
*.iopin ynp
*.iopin ynm
*.iopin znm
*.iopin znp
*.iopin xp
*.iopin xn
x00b[1] bnb bnb bna_[1] avss n2_4
x00b[0] bnb bnb bna_[0] avss n2_4
x02c[1] bpb bna avss avss n1_4
x02c[0] bpb bna avss avss n1_4
x02b[1] bpb bpb bpa_[1] avdd p2_4
x02b[0] bpb bpb bpa_[0] avdd p2_4
x02a[1] bpa_[1] bpa avdd avdd p1_4
x02a[0] bpa_[0] bpa avdd avdd p1_4
x10b[1] ynp im xp avdd p4_1
x10b[0] ynp im xp avdd p4_1
x11a[1] xp bpa avdd avdd p1_4
x11a[0] xp bpa avdd avdd p1_4
x11b[1] ynm ip xp avdd p4_1
x11b[0] ynm ip xp avdd p4_1
x13a[1] wp[1] bpa avdd avdd p1_4
x13a[0] wp[0] bpa avdd avdd p1_4
x13c[1] znp znp ynp avss n3_1
x13c[0] znp znp ynp avss n3_1
x3d[3] ynp znp avss avss n1_4
x3d[2] ynp znp avss avss n1_4
x3d[1] ynp znp avss avss n1_4
x3d[0] ynp znp avss avss n1_4
x13b[1] znp bpb wp[1] avdd p1_3
x13b[0] znp bpb wp[0] avdd p1_3
x14f[3] ynm znp avss avss n1_4
x14f[2] ynm znp avss avss n1_4
x14f[1] ynm znp avss avss n1_4
x14f[0] ynm znp avss avss n1_4
x14e[1] znm znp ynm avss n3_1
x14e[0] znm znp ynm avss n3_1
x10a[1] xp bpa avdd avdd p1_4
x10a[0] xp bpa avdd avdd p1_4
x10d[1] xn bna avss avss n1_4
x10d[0] xn bna avss avss n1_4
x11d[1] xn bna avss avss n1_4
x11d[0] xn bna avss avss n1_4
x10c[1] ypp im xn avss n4_1
x10c[0] ypp im xn avss n4_1
x11c[1] ypm ip xn avss n4_1
x11c[0] ypm ip xn avss n4_1
x12d[1] wn[1] bna avss avss n1_4
x12d[0] wn[0] bna avss avss n1_4
x12c[1] zpp bnb wn[1] avss n1_3
x12c[0] zpp bnb wn[0] avss n1_3
x12b[1] zpp zpp ypp avdd p3_1
x12b[0] zpp zpp ypp avdd p3_1
x12a[3] ypp zpp avdd avdd p1_4
x12a[2] ypp zpp avdd avdd p1_4
x12a[1] ypp zpp avdd avdd p1_4
x12a[0] ypp zpp avdd avdd p1_4
x14b[1] zpm zpp ypm avdd p3_1
x14b[0] zpm zpp ypm avdd p3_1
x14a[3] ypm zpp avdd avdd p1_4
x14a[2] ypm zpp avdd avdd p1_4
x14a[1] ypm zpp avdd avdd p1_4
x14a[0] ypm zpp avdd avdd p1_4
x14c[1] znm bpb zpm avdd p1_4
x14c[0] znm bpb zpm avdd p1_4
x14d[1] zpm bnb znm avss n1_4
x14d[0] zpm bnb znm avss n1_4
x21b[1] o znm avss avss n4_1
x21b[0] o znm avss avss n4_1
x21a[1] o zpm avdd avdd p4_1
x21a[0] o zpm avdd avdd p4_1
x01c[1] bna enb avss avss n1_1
x01c[0] bna enb avss avss n1_1
x01b[1] bna_[1] en bna avss n1_1
x01b[0] bna_[0] en bna avss n1_1
x00c[1] bna_[1] bna avss avss n1_4
x00c[0] bna_[0] bna avss avss n1_4
x03a[1] bpa en avdd avdd p1_1
x03a[0] bpa en avdd avdd p1_1
x03b[1] bpa_[1] enb bpa avdd p1_1
x03b[0] bpa_[0] enb bpa avdd p1_1
x00a[1] avdd bpa avdd avdd p1_4
x00a[0] avdd bpa avdd avdd p1_4
x20b[1] znm enb avss avss n1_1
x20b[0] znm enb avss avss n1_1
x20a[1] zpm en avdd avdd p4_1
x20a[0] zpm en avdd avdd p4_1
.ends


* expanding   symbol:  n2_4.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n2_4.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n2_4.sch
.subckt n2_4  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xr D G S B n1_4
xl D G S B n1_4
.ends


* expanding   symbol:  n1_4.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_4.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_4.sch
.subckt n1_4  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xd D G X B n1_2
xs X G S B n1_2
.ends


* expanding   symbol:  p2_4.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p2_4.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p2_4.sch
.subckt p2_4  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xl D G S B p1_4
xr D G S B p1_4
.ends


* expanding   symbol:  p1_4.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_4.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_4.sch
.subckt p1_4  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xs X G S B p1_2
xd D G X B p1_2
.ends


* expanding   symbol:  p4_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p4_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p4_1.sch
.subckt p4_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xl D G S B p2_1
xr D G S B p2_1
.ends


* expanding   symbol:  n3_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n3_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n3_1.sch
.subckt n3_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xr D G S B n1_1
xl D G S B n2_1
.ends


* expanding   symbol:  p1_3.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_3.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_3.sch
.subckt p1_3  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xs X G S B p1_2
xd D G X B p1_1
.ends


* expanding   symbol:  n4_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n4_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n4_1.sch
.subckt n4_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xr D G S B n2_1
xl D G S B n2_1
.ends


* expanding   symbol:  n1_3.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_3.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_3.sch
.subckt n1_3  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xd D G X B n1_1
xs X G S B n1_2
.ends


* expanding   symbol:  p3_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p3_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p3_1.sch
.subckt p3_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xl D G S B p2_1
xr D G S B p1_1
.ends


* expanding   symbol:  n1_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_1.sch
.subckt n1_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
XMD[1] D G X[1] B sky130_fd_pr__nfet_g5v0d10v5 L=1.0 W=7 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
XMD[0] D G X[0] B sky130_fd_pr__nfet_g5v0d10v5 L=1.0 W=7 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
XMS[1] X[1] G S B sky130_fd_pr__nfet_g5v0d10v5 L=1.0 W=7 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
XMS[0] X[0] G S B sky130_fd_pr__nfet_g5v0d10v5 L=1.0 W=7 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
.ends


* expanding   symbol:  p1_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_1.sch
.subckt p1_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
XM0[3] D G S B sky130_fd_pr__pfet_g5v0d10v5 L=1.0 W=5.0 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
XM0[2] D G S B sky130_fd_pr__pfet_g5v0d10v5 L=1.0 W=5.0 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
XM0[1] D G S B sky130_fd_pr__pfet_g5v0d10v5 L=1.0 W=5.0 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
XM0[0] D G S B sky130_fd_pr__pfet_g5v0d10v5 L=1.0 W=5.0 nf=1 ad='int((nf+1)/2) * W/nf * 0.29' as='int((nf+2)/2) * W/nf * 0.29'
+ pd='2*int((nf+1)/2) * (W/nf + 0.29)' ps='2*int((nf+2)/2) * (W/nf + 0.29)' nrd='0.29 / W' nrs='0.29 / W'
+ sa=0 sb=0 sd=0 mult=1 m=1 
.ends


* expanding   symbol:  n1_2.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_2.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n1_2.sch
.subckt n1_2  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xd D G X B n1_1
xs X G S B n1_1
.ends


* expanding   symbol:  p1_2.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_2.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p1_2.sch
.subckt p1_2  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xs X G S B p1_1
xd D G X B p1_1
.ends


* expanding   symbol:  p2_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p2_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/p2_1.sch
.subckt p2_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xl D G S B p1_1
xr D G S B p1_1
.ends


* expanding   symbol:  n2_1.sym # of pins=4
* sym_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n2_1.sym
* sch_path: /home/rodovalho/git/sky130_rodovalho_ip__lpopamp/xschem/n2_1.sch
.subckt n2_1  D  G  S  B
*.iopin D
*.iopin G
*.iopin S
*.iopin B
xr D G S B n1_1
xl D G S B n1_1
.ends

.GLOBAL GND
** flattened .save nodes
.end