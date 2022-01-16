---
title: "Public Key Cryptography"
draft: false
weight: 10
katex: true
---

# Public Key Cryptography

Public key cryptography is a cryptographic scheme that uses two keys, a public key and a private key. It is used for signature, key exchange and etc.

The security is ensured by using the difficulty of the calculation.
For example, given $x$, it is easy to compute $y$ such that $y=f(x)$, but it is difficult to compute $x$ from $y$.

## RSA

RSA is a cryptosystem that relies on the difficulty of prime factorization.
It is easy to compute the composite number $n = pq$ for two primes $p, q$, but it is difficult to compute the factors $q, p$ from $n$.

### **Algorithm**

This section explains the algorithm used to exchange messages securely using RSA. Let Alice be the receiver of the message and Bob be the sender.

#### **Key Generation**

Alice generates a key by doing the following: 

1. Choose two large prime numbers $p, q$ and compute $N = pq$.
2. Choose a natural number $e$ such that $\gcd((p-1)(q-1), e) = 1$.
3. Find $d$ such that $ed \equiv 1 \pmod{(p-1)(q-1)}$.
4. Let $key_p = (N, e)$ be the public key and $key_s = d$ be the private key.

#### **Encryption**

Bob takes $key_p = (N,e)$ and the plaintext $M \in {0,1,2, \dots , N-1}$ as inputs and find the ciphertext:

$$
C = M^e \pmod N
$$

#### **Decryption**

Alice finds $M'$ from $key_s = d$ and $C$ as follows.

$$
M' \equiv C^d \pmod N
$$

Here $M = M'$, so we can recover the message.

### **Signature Algorithm**

A signature can satisfy the authentication and non-repudiation requirements of security.

> Authentication: Certificates that the signer is a valid signer.
>
> Non-requdiation: The signer cannot deny the signature later.

#### **Signature**

Signed by: Alice, Received by: Bob

1. Alice creates a public key $key_p = (N, e)$ and a private key $key_s = d$.
2. Alice computes the signature $\sigma^e\equiv M^d\pmod N$ for the message $M \in {0,\dots,N-1}$ and sends $(M, \sigma)$ to Bob.
3. Bob uses the received $(M, \sigma)$ and the public key $(N,e)$ to verify that $\sigma^e\equiv M\pmod N$ is true, and accepts if it is, or rejects otherwise.

> From properties of the RSA cipher:
>
> $$
> \sigma^e = (M^d)^e = M^{ed} \equiv M \pmod N
> $$
