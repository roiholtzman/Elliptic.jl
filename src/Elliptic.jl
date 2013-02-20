module Elliptic

# elliptic integrals of 1st/2nd/3rd kind
export E, F, K, Pi

# jacobi elliptic functions
export am, sn, cn, dn, cd, sd, nd, dc, nc, sc, ns, ds, cs

# matlab compatible
export ellipj, ellipke

include("slatec.jl")

function E(phi::Float64, m::Float64)
    if m < 0. || m > 1. throw(DomainError()) end
    sinphi = sin(phi)
    sinphi2 = sinphi^2
    cosphi2 = 1. - sinphi2
    y = 1. - m*sinphi2
    drf,ierr1 = SLATEC.DRF(cosphi2, y, 1.)
    drd,ierr2 = SLATEC.DRD(cosphi2, y, 1.)
    @assert ierr1 == 0 && ierr2 == 0
    sinphi*(drf - m*sinphi2*drd/3)
end
E(phi::Real, m::Real) = E(float64(phi), float64(m))
@vectorize_2arg Real E

function ellipke(m::Float64)
    if m < 0. || m > 1. throw(DomainError()) end
    if m == 1. return Inf, 1. end
    y = 1. - m
    drf,ierr1 = SLATEC.DRF(0., y, 1.)
    drd,ierr2 = SLATEC.DRD(0., y, 1.)
    @assert ierr1 == 0 && ierr2 == 0
    drf, drf - m*drd/3
end
ellipke(x::Real) = ellipke(float64(x))

E(m::Float64) = ellipke(m)[2]
E(x::Float32) = float32(E(float64(x)))
E(x::Real) = E(float64(x))
@vectorize_1arg Real E

# assumes 0 ≤ m ≤ 1
function rawF(sinphi::Float64, m::Float64)
    sinphi2 = sinphi^2
    drf,ierr = SLATEC.DRF(1. - sinphi2, 1. - m*sinphi2, 1.)
    @assert ierr == 0
    sinphi*drf
end

function F(phi::Float64, m::Float64)
    if m < 0. || m > 1. throw(DomainError()) end
    if abs(phi) > pi/2
        # Abramowitz & Stegun (17.4.3)
        phi2 = phi + pi/2
        return F(mod(phi2,pi) - pi/2,m) + 2*fld(phi2,pi)*K(m)
    end
    rawF(sin(phi), m)
end
F(phi::Real, m::Real) = F(float64(phi), float64(m))
@vectorize_2arg Real F

function K(m::Float64)
    if m < 0. || m > 1. throw(DomainError()) end
    if m == 1. return Inf end
    drf,ierr = SLATEC.DRF(0., 1. - m, 1.)
    @assert ierr == 0
    drf
end
K(x::Float32) = float32(K(float64(x)))
K(x::Real) = K(float64(x))
@vectorize_1arg Real K

function Pi(n::Float64, phi::Float64, m::Float64)
    if m < 0. || m > 1. throw(DomainError()) end
    sinphi = sin(phi)
    sinphi2 = sinphi^2
    cosphi2 = 1. - sinphi2
    y = 1. - m*sinphi2
    drf,ierr1 = SLATEC.DRF(cosphi2, y, 1.)
    drj,ierr2 = SLATEC.DRJ(cosphi2, y, 1., 1. - n*sinphi2)
    @assert ierr1 == 0 && ierr2 == 0
    sinphi*(drf + n*sinphi2*drj/3)
end
Pi(n::Real, phi::Real, m::Real) = Pi(float64(n), float64(phi), float64(m))

function am(u::Float64, m::Float64, tol::Float64)
    if m < 0. || m > 1. throw(DomainError()) end

    a,b,c,n = 1., sqrt(1.-m), sqrt(m), 0
    if b == 0. return sin(u), cos(u), 1. end
    if c == 1. s = sech(u); return tanh(u), s, s end

    ca = [c/a]
    while abs(c) > tol
        a,b,c,n = 0.5*(a+b), sqrt(a*b), 0.5*(a-b), n+1
        push!(ca, c/a)
    end

    phi = ldexp(a*u, n)
    for i = n:-1:1
        phi = 0.5*(phi + asin(ca[i+1]*sin(phi)))
    end
    phi
end
am(u::Float64, m::Float64) = am(u, m, eps(Float64))

function ellipj(u::Float64, m::Float64, tol::Float64)
    phi = am(u, m, tol)
    sn = sin(phi)
    cn = cos(phi)
    dn = sqrt(1. - m*sn^2)
    sn, cn, dn
end
ellipj(u::Float64, m::Float64) = ellipj(u, m, eps(Float64))
ellipj(u::Real, m::Real) = ellipj(float64(phi), float64(m))
@vectorize_2arg Real ellipj

sn(u::Float64, m::Float64) = sin(am(u,m))
cn(u::Float64, m::Float64) = cos(am(u,m))
dn(u::Float64, m::Float64) = sqrt(1.-m*sn(u,m)^2)

cd(u::Float64, m::Float64) = (phi=am(u,m); cos(phi)/sqrt(1.-m*sin(phi)^2))
sd(u::Float64, m::Float64) = (s=sn(u,m); s/sqrt(1.-m*s^2))
nd(u::Float64, m::Float64) = 1/dn(u,m)

dc(u::Float64, m::Float64) = (phi=am(u,m); sqrt(1.-m*sin(phi)^2)/cos(phi))
nc(u::Float64, m::Float64) = 1/cn(u,m)
sc(u::Float64, m::Float64) = (phi=am(u,m); sin(phi)/cos(phi))

ns(u::Float64, m::Float64) = 1/sn(u,m)
ds(u::Float64, m::Float64) = (s=sn(u,m); sqrt(1.-m*s^2)/s)
cs(u::Float64, m::Float64) = (phi=am(u,m); cos(phi)/sin(phi))

for f in (:am, :sn, :cn, :dn, :cd, :sd, :nd, :dc, :nc, :sc, :ns, :ds, :cs)
    @eval begin
        ($f)(u::Real, m::Real) = ($f)(float64(u), float64(m))
        @vectorize_2arg Real $f
    end
end

end # module
