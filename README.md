This project is a cryptographically secure random number generator design. AES and chatoic RNG are connected to the processor system via Wishbone bus. Cryto secure RNG mode is turned during runtime.

The AES hardware implementation is designed by Joachim Strömbergson at the following github repository.

https://github.com/secworks/aes

The chaotic RNG is designed by Onur Karatas from Tübitak at the following Github repository.

https://github.com/onurkrts/RNG-SCROLL

They are connected to the Wishbone bus interface to be used individually. When the crypto secure RNG mode is activated, they start working together to produce cryptographically secure random data.