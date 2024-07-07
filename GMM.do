
* PANEL GMM

* Arellano & Bond (1961)  

/*
1976 - 1984 yılları arasında United Kingdom firmaları için işgücü talebini modellemekte kullanılıyor.

İşgücü üzerinde ücretlerin, sermaye stoğunun ve endüstri üretiminin gecikmeli etkisini bulmak amacı

n_it= β_0 + β_1 * n_it-1 + β_2 * n_it-2 + β_3 * w_it + β_4 * w_it-1 + β_5 * ys_it + β_6 * ys_it-1 + β_6 * k_it + u_it

n : İşgücünün logaritması

w : Ücretlerin logaritması

k : Sermaye stoğunun logaritması

ys : firmanın bulunduğu endüstrinin logaritması

i: id (firmalar) 140 firma

t : year (yıl) 1976 - 1984  
*/

* A. Gölge Değişkenli En Küçük Kareler, Anderson ve Hsiao'nun Araç Değişkenli Birinci Farklar Tahmincileri

use http://www.stata-press.com/data/r11/abdata.dta

xtset id year 

quietly xtreg l(0/1).(n w ys) k, fe robust

estimates store lsdv

help xtlsdvc

quietly xtlsdvc n w wL1 ys ysL1 k, initial(ah) vcov(50) bias(1)
estimates store lsdvb1

quietly xtlsdvc n w wL1 ys ysL1 k, initial(ah) vcov(50) bias(2)
estimates store lsdvb2

quietly xtlsdvc n w wL1 ys ysL1 k, initial(ah) vcov(50) bias(3)
estimates store lsdvb3

quietly ivregress 2sls D.n (LD.n=L2.n) D.(l(0/1).(w ys) k), noconstant vce(robust)
estimates store ahl2

quietly ivregress 2sls D.n (LD.n=L2D.n) D.(l(0/1).(w ys) k), noconstant vce(robust)
estimates store ahl2d

estimates table lsdv lsdvb1 lsdvb2 lsdvb3 ahl2 ahl2d, b(%7.3g) star stat(N r2)

* B. Arellano ve Bond Tahmincisi

quietly xtabond n l(0/1).(w ys) k, lag(1) noconstant robust
estimates store abond

quietly xtabond n l(0/1).(w ys) k, lag(1) twostep noconstant robust 
estimates store abondtwo

quietly xtlsdvc n w wL1 ys ysL1 k, initial(ab) vcov(50) bias(1)
estimates store abb1

quietly xtlsdvc n w wL1 ys ysL1 k, initial(ab) vcov(50) bias(2)
estimates store abb2

quietly xtlsdvc n w wL1 ys ysL1 k, initial(ab) vcov(50) bias(3)
estimates store abb3

estimates table abond abondtwo abb1 abb2 abb3, b(%7.3g) star stat(N arm1 arm2)

* C. Arellano ve Bover / Blundell ve Bond Sistem Genelleştirilmiş Momentler Tahmincisi

quietly xtdpdsys n l(0/1).(w ys) k, lag(1) noconstant vce(robust)
estimates store bb

quietly xtdpdsys n l(0/1).(w ys) k, lag(1) noconstant twostep vce(robust)
estimates store bbtwo

help xtabond2

quietly xtabond2 n l(0/1).(w ys) k, noconstant gmm(L.n) iv(l(0/1).(w ys) k) orthogonal robust
estimates store abond2

quietly xtabond2 n l(0/1).(w ys) k, noconstant gmm(L.n) iv(l(0/1).(w ys) k) orthogonal twostep robust
estimates store abond2two

quietly xtlsdvc n w wL1 ys ysL1 k, initial(bb) vcov(50) bias(1)
estimates store bb1

quietly xtlsdvc n w wL1 ys ysL1 k, initial(bb) vcov(50) bias(2)
estimates store bb2

quietly xtlsdvc n w wL1 ys ysL1 k, initial(bb) vcov(50) bias(3)
estimates store bb3

estimates table bb bbtwo abond2 abond2two bb1 bb2 bb3, b(%7.3g) star stat(N chi2 arm1 arm2 ar1 ar1p ar2 ar2p hansen hansenp) stfmt(%4.2f)


