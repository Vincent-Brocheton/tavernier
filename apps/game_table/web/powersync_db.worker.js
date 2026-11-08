(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.F1(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.u(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.wf(b)
return new s(c,this)}:function(){if(s===null)s=A.wf(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.wf(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
wo(a,b,c,d){return{i:a,p:b,e:c,x:d}},
uJ(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.wm==null){A.Ez()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.a(A.vI("Return interceptor for "+A.q(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.t_
if(o==null)o=$.t_=A.uI(n)
p=q[o]}if(p!=null)return p
p=A.EJ(a)
if(p!=null)return p
if(typeof a=="function")return B.bl
s=Object.getPrototypeOf(a)
if(s==null)return B.ah
if(s===Object.prototype)return B.ah
if(typeof q=="function"){o=$.t_
if(o==null)o=$.t_=A.uI(n)
Object.defineProperty(q,o,{value:B.a_,enumerable:false,writable:true,configurable:true})
return B.a_}return B.a_},
vs(a,b){if(a<0||a>4294967295)throw A.a(A.ac(a,0,4294967295,"length",null))
return J.AL(new Array(a),b)},
AK(a,b){if(a<0)throw A.a(A.J("Length must be a non-negative integer: "+a,null))
return A.u(new Array(a),b.h("w<0>"))},
AL(a,b){var s=A.u(a,b.h("w<0>"))
s.$flags=1
return s},
AM(a,b){return J.wx(a,b)},
dB(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.fl.prototype
return J.iA.prototype}if(typeof a=="string")return J.cm.prototype
if(a==null)return J.dR.prototype
if(typeof a=="boolean")return J.iz.prototype
if(Array.isArray(a))return J.w.prototype
if(typeof a!="object"){if(typeof a=="function")return J.b2.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.uJ(a)},
ab(a){if(typeof a=="string")return J.cm.prototype
if(a==null)return a
if(Array.isArray(a))return J.w.prototype
if(typeof a!="object"){if(typeof a=="function")return J.b2.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.uJ(a)},
bn(a){if(a==null)return a
if(Array.isArray(a))return J.w.prototype
if(typeof a!="object"){if(typeof a=="function")return J.b2.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.uJ(a)},
Et(a){if(typeof a=="number")return J.dS.prototype
if(typeof a=="string")return J.cm.prototype
if(a==null)return a
if(!(a instanceof A.k))return J.de.prototype
return a},
wk(a){if(typeof a=="string")return J.cm.prototype
if(a==null)return a
if(!(a instanceof A.k))return J.de.prototype
return a},
uH(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.b2.prototype
if(typeof a=="symbol")return J.dT.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.uJ(a)},
A(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.dB(a).D(a,b)},
eV(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.z1(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.ab(a).i(a,b)},
kZ(a,b,c){if(typeof b==="number")if((Array.isArray(a)||A.z1(a,a[v.dispatchPropertyName]))&&!(a.$flags&2)&&b>>>0===b&&b<a.length)return a[b]=c
return J.bn(a).l(a,b,c)},
hP(a,b){return J.bn(a).q(a,b)},
zT(a,b){return J.bn(a).aa(a,b)},
zU(a,b){return J.wk(a).e7(a,b)},
zV(a){return J.uH(a).j0(a)},
cM(a,b,c){return J.uH(a).e8(a,b,c)},
zW(a,b){return J.bn(a).ea(a,b)},
wx(a,b){return J.Et(a).a_(a,b)},
wy(a,b){return J.ab(a).U(a,b)},
l_(a,b){return J.bn(a).V(a,b)},
zX(a){return J.uH(a).gar(a)},
V(a){return J.dB(a).gv(a)},
l0(a){return J.ab(a).gF(a)},
zY(a){return J.ab(a).gaP(a)},
Z(a){return J.bn(a).gA(a)},
aN(a){return J.ab(a).gk(a)},
zZ(a){return J.uH(a).gjB(a)},
wz(a){return J.dB(a).ga4(a)},
dE(a,b,c){return J.bn(a).b9(a,b,c)},
A_(a,b,c){return J.wk(a).cC(a,b,c)},
A0(a,b){return J.ab(a).sk(a,b)},
A1(a,b,c,d,e){return J.bn(a).X(a,b,c,d,e)},
l1(a,b){return J.bn(a).aU(a,b)},
wA(a,b){return J.bn(a).cP(a,b)},
A2(a,b){return J.wk(a).dL(a,b)},
wB(a,b){return J.bn(a).bO(a,b)},
A3(a){return J.bn(a).jS(a)},
be(a){return J.dB(a).j(a)},
ix:function ix(){},
iz:function iz(){},
dR:function dR(){},
ai:function ai(){},
cn:function cn(){},
iY:function iY(){},
de:function de(){},
b2:function b2(){},
aQ:function aQ(){},
dT:function dT(){},
w:function w(a){this.$ti=a},
iy:function iy(){},
nI:function nI(a){this.$ti=a},
dF:function dF(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
dS:function dS(){},
fl:function fl(){},
iA:function iA(){},
cm:function cm(){}},A={vv:function vv(){},
i6(a,b,c){if(t.O.b(a))return new A.h9(a,b.h("@<0>").I(c).h("h9<1,2>"))
return new A.cQ(a,b.h("@<0>").I(c).h("cQ<1,2>"))},
x1(a){return new A.d_("Field '"+a+"' has been assigned during initialization.")},
x2(a){return new A.d_("Field '"+a+"' has not been initialized.")},
AQ(a){return new A.d_("Field '"+a+"' has already been initialized.")},
uM(a){var s,r=a^48
if(r<=9)return r
s=a|32
if(97<=s&&s<=102)return s-87
return-1},
av(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
fN(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
xx(a,b,c){return A.fN(A.av(A.av(c,a),b))},
bd(a,b,c){return a},
wn(a){var s,r
for(s=$.dy.length,r=0;r<s;++r)if(a===$.dy[r])return!0
return!1},
bK(a,b,c,d){A.aI(b,"start")
if(c!=null){A.aI(c,"end")
if(b>c)A.r(A.ac(b,0,c,"start",null))}return new A.db(a,b,c,d.h("db<0>"))},
nU(a,b,c,d){if(t.O.b(a))return new A.bU(a,b,c.h("@<0>").I(d).h("bU<1,2>"))
return new A.bY(a,b,c.h("@<0>").I(d).h("bY<1,2>"))},
xy(a,b,c){var s="takeCount"
A.hS(b,s)
A.aI(b,s)
if(t.O.b(a))return new A.fa(a,b,c.h("fa<0>"))
return new A.dd(a,b,c.h("dd<0>"))},
xr(a,b,c){var s="count"
if(t.O.b(a)){A.hS(b,s)
A.aI(b,s)
return new A.dM(a,b,c.h("dM<0>"))}A.hS(b,s)
A.aI(b,s)
return new A.c1(a,b,c.h("c1<0>"))},
bW(){return new A.aX("No element")},
wY(){return new A.aX("Too few elements")},
ja(a,b,c,d){if(c-b<=32)A.Bn(a,b,c,d)
else A.Bm(a,b,c,d)},
Bn(a,b,c,d){var s,r,q,p,o
for(s=b+1,r=J.ab(a);s<=c;++s){q=r.i(a,s)
p=s
for(;;){if(!(p>b&&d.$2(r.i(a,p-1),q)>0))break
o=p-1
r.l(a,p,r.i(a,o))
p=o}r.l(a,p,q)}},
Bm(a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i=B.b.Y(a5-a4+1,6),h=a4+i,g=a5-i,f=B.b.Y(a4+a5,2),e=f-i,d=f+i,c=J.ab(a3),b=c.i(a3,h),a=c.i(a3,e),a0=c.i(a3,f),a1=c.i(a3,d),a2=c.i(a3,g)
if(a6.$2(b,a)>0){s=a
a=b
b=s}if(a6.$2(a1,a2)>0){s=a2
a2=a1
a1=s}if(a6.$2(b,a0)>0){s=a0
a0=b
b=s}if(a6.$2(a,a0)>0){s=a0
a0=a
a=s}if(a6.$2(b,a1)>0){s=a1
a1=b
b=s}if(a6.$2(a0,a1)>0){s=a1
a1=a0
a0=s}if(a6.$2(a,a2)>0){s=a2
a2=a
a=s}if(a6.$2(a,a0)>0){s=a0
a0=a
a=s}if(a6.$2(a1,a2)>0){s=a2
a2=a1
a1=s}c.l(a3,h,b)
c.l(a3,f,a0)
c.l(a3,g,a2)
c.l(a3,e,c.i(a3,a4))
c.l(a3,d,c.i(a3,a5))
r=a4+1
q=a5-1
p=J.A(a6.$2(a,a1),0)
if(p)for(o=r;o<=q;++o){n=c.i(a3,o)
m=a6.$2(n,a)
if(m===0)continue
if(m<0){if(o!==r){c.l(a3,o,c.i(a3,r))
c.l(a3,r,n)}++r}else for(;;){m=a6.$2(c.i(a3,q),a)
if(m>0){--q
continue}else{l=q-1
if(m<0){c.l(a3,o,c.i(a3,r))
k=r+1
c.l(a3,r,c.i(a3,q))
c.l(a3,q,n)
q=l
r=k
break}else{c.l(a3,o,c.i(a3,q))
c.l(a3,q,n)
q=l
break}}}}else for(o=r;o<=q;++o){n=c.i(a3,o)
if(a6.$2(n,a)<0){if(o!==r){c.l(a3,o,c.i(a3,r))
c.l(a3,r,n)}++r}else if(a6.$2(n,a1)>0)for(;;)if(a6.$2(c.i(a3,q),a1)>0){--q
if(q<o)break
continue}else{l=q-1
if(a6.$2(c.i(a3,q),a)<0){c.l(a3,o,c.i(a3,r))
k=r+1
c.l(a3,r,c.i(a3,q))
c.l(a3,q,n)
r=k}else{c.l(a3,o,c.i(a3,q))
c.l(a3,q,n)}q=l
break}}j=r-1
c.l(a3,a4,c.i(a3,j))
c.l(a3,j,a)
j=q+1
c.l(a3,a5,c.i(a3,j))
c.l(a3,j,a1)
A.ja(a3,a4,r-2,a6)
A.ja(a3,q+2,a5,a6)
if(p)return
if(r<h&&q>g){while(J.A(a6.$2(c.i(a3,r),a),0))++r
while(J.A(a6.$2(c.i(a3,q),a1),0))--q
for(o=r;o<=q;++o){n=c.i(a3,o)
if(a6.$2(n,a)===0){if(o!==r){c.l(a3,o,c.i(a3,r))
c.l(a3,r,n)}++r}else if(a6.$2(n,a1)===0)for(;;)if(a6.$2(c.i(a3,q),a1)===0){--q
if(q<o)break
continue}else{l=q-1
if(a6.$2(c.i(a3,q),a)<0){c.l(a3,o,c.i(a3,r))
k=r+1
c.l(a3,r,c.i(a3,q))
c.l(a3,q,n)
r=k}else{c.l(a3,o,c.i(a3,q))
c.l(a3,q,n)}q=l
break}}A.ja(a3,r,q,a6)}else A.ja(a3,r,q,a6)},
cS:function cS(a,b){this.a=a
this.$ti=b},
dG:function dG(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
cz:function cz(){},
i7:function i7(a,b){this.a=a
this.$ti=b},
cQ:function cQ(a,b){this.a=a
this.$ti=b},
h9:function h9(a,b){this.a=a
this.$ti=b},
h3:function h3(){},
qY:function qY(a,b){this.a=a
this.b=b},
ag:function ag(a,b){this.a=a
this.$ti=b},
cR:function cR(a,b){this.a=a
this.$ti=b},
lF:function lF(a,b){this.a=a
this.b=b},
lE:function lE(a){this.a=a},
d_:function d_(a){this.a=a},
br:function br(a){this.a=a},
v2:function v2(){},
ox:function ox(){},
x:function x(){},
X:function X(){},
db:function db(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
at:function at(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bY:function bY(a,b,c){this.a=a
this.b=b
this.$ti=c},
bU:function bU(a,b,c){this.a=a
this.b=b
this.$ti=c},
cp:function cp(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
a8:function a8(a,b,c){this.a=a
this.b=b
this.$ti=c},
c7:function c7(a,b,c){this.a=a
this.b=b
this.$ti=c},
ef:function ef(a,b){this.a=a
this.b=b},
fc:function fc(a,b,c){this.a=a
this.b=b
this.$ti=c},
im:function im(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
dd:function dd(a,b,c){this.a=a
this.b=b
this.$ti=c},
fa:function fa(a,b,c){this.a=a
this.b=b
this.$ti=c},
jo:function jo(a,b,c){this.a=a
this.b=b
this.$ti=c},
c1:function c1(a,b,c){this.a=a
this.b=b
this.$ti=c},
dM:function dM(a,b,c){this.a=a
this.b=b
this.$ti=c},
j9:function j9(a,b){this.a=a
this.b=b},
cX:function cX(a){this.$ti=a},
ii:function ii(){},
fX:function fX(a,b){this.a=a
this.$ti=b},
jB:function jB(a,b){this.a=a
this.$ti=b},
fz:function fz(a,b){this.a=a
this.$ti=b},
iS:function iS(a){this.a=a
this.b=null},
ff:function ff(){},
jr:function jr(){},
eb:function eb(){},
d8:function d8(a,b){this.a=a
this.$ti=b},
fL:function fL(a){this.a=a},
hG:function hG(){},
Ak(){throw A.a(A.P("Cannot modify unmodifiable Map"))},
Al(){throw A.a(A.P("Cannot modify constant Set"))},
zh(a){var s=A.zg(a)
if(s!=null)return s
return"minified:"+a},
z1(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.dX.b(a)},
q(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.be(a)
return s},
e0(a){var s,r=$.xd
if(r==null)r=$.xd=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
vA(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
j_(a){var s,r,q,p
if(a instanceof A.k)return A.bc(A.bo(a),null)
s=J.dB(a)
if(s===B.bk||s===B.bm||t.cx.b(a)){r=B.a3(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.bc(A.bo(a),null)},
xk(a){var s,r,q
if(a==null||typeof a=="number"||A.kN(a))return J.be(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.cT)return a.j(0)
if(a instanceof A.hn)return a.iP(!0)
s=$.zN()
for(r=0;r<1;++r){q=s[r].p6(a)
if(q!=null)return q}return"Instance of '"+A.j_(a)+"'"},
B3(){if(!!self.location)return self.location.href
return null},
xc(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
B7(a){var s,r,q,p=A.u([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r){q=a[r]
if(!A.hH(q))throw A.a(A.dz(q))
if(q<=65535)p.push(q)
else if(q<=1114111){p.push(55296+(B.b.a2(q-65536,10)&1023))
p.push(56320+(q&1023))}else throw A.a(A.dz(q))}return A.xc(p)},
xl(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.hH(q))throw A.a(A.dz(q))
if(q<0)throw A.a(A.dz(q))
if(q>65535)return A.B7(a)}return A.xc(a)},
B8(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
aR(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.b.a2(s,10)|55296)>>>0,s&1023|56320)}}throw A.a(A.ac(a,0,1114111,null,null))},
d5(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
xj(a){var s=A.d5(a).getFullYear()+0
return s},
xh(a){var s=A.d5(a).getMonth()+1
return s},
xe(a){var s=A.d5(a).getDate()+0
return s},
xf(a){var s=A.d5(a).getHours()+0
return s},
xg(a){var s=A.d5(a).getMinutes()+0
return s},
xi(a){var s=A.d5(a).getSeconds()+0
return s},
B5(a){var s=A.d5(a).getMilliseconds()+0
return s},
B6(a){var s=A.d5(a).getDay()+0
return B.b.aT(s+6,7)+1},
B4(a){var s=a.$thrownJsError
if(s==null)return null
return A.I(s)},
j0(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.an(a,s)
a.$thrownJsError=s
s.stack=b.j(0)}},
kS(a,b){var s,r="index"
if(!A.hH(b))return new A.a3(!0,b,r,null)
s=J.aN(a)
if(b<0||b>=s)return A.iu(b,s,a,null,r)
return A.of(b,r)},
Em(a,b,c){if(a<0||a>c)return A.ac(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ac(b,a,c,"end",null)
return new A.a3(!0,b,"end",null)},
dz(a){return new A.a3(!0,a,null,null)},
a(a){return A.an(a,new Error())},
an(a,b){var s
if(a==null)a=new A.c4()
b.dartException=a
s=A.F2
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
F2(){return J.be(this.dartException)},
r(a,b){throw A.an(a,b==null?new Error():b)},
C(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.r(A.D4(a,b,c),s)},
D4(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.fR("'"+s+"': Cannot "+o+" "+l+k+n)},
a6(a){throw A.a(A.ao(a))},
c5(a){var s,r,q,p,o,n
a=A.z8(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.u([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.pB(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
pC(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
xB(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
vw(a,b){var s=b==null,r=s?null:b.method
return new A.iB(a,r,s?null:b.receiver)},
E(a){if(a==null)return new A.iU(a)
if(a instanceof A.fb)return A.cJ(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.cJ(a,a.dartException)
return A.DU(a)},
cJ(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
DU(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.b.a2(r,16)&8191)===10)switch(q){case 438:return A.cJ(a,A.vw(A.q(s)+" (Error "+q+")",null))
case 445:case 5007:A.q(s)
return A.cJ(a,new A.fA())}}if(a instanceof TypeError){p=$.zo()
o=$.zp()
n=$.zq()
m=$.zr()
l=$.zu()
k=$.zv()
j=$.zt()
$.zs()
i=$.zx()
h=$.zw()
g=p.ba(s)
if(g!=null)return A.cJ(a,A.vw(s,g))
else{g=o.ba(s)
if(g!=null){g.method="call"
return A.cJ(a,A.vw(s,g))}else if(n.ba(s)!=null||m.ba(s)!=null||l.ba(s)!=null||k.ba(s)!=null||j.ba(s)!=null||m.ba(s)!=null||i.ba(s)!=null||h.ba(s)!=null)return A.cJ(a,new A.fA())}return A.cJ(a,new A.jq(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.fG()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.cJ(a,new A.a3(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.fG()
return a},
I(a){var s
if(a instanceof A.fb)return a.b
if(a==null)return new A.hu(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.hu(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
kT(a){if(a==null)return J.V(a)
if(typeof a=="object")return A.e0(a)
return J.V(a)},
Er(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.l(0,a[s],a[r])}return b},
Df(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.a(A.wQ("Unsupported number of arguments for wrapped closure"))},
cI(a,b){var s
if(a==null)return null
s=a.$identity
if(!!s)return s
s=A.Eg(a,b)
a.$identity=s
return s},
Eg(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.Df)},
Ae(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.oI().constructor.prototype):Object.create(new A.eX(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.wM(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.Aa(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.wM(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
Aa(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.a("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.A6)}throw A.a("Error in functionType of tearoff")},
Ab(a,b,c,d){var s=A.wI
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
wM(a,b,c,d){if(c)return A.Ad(a,b,d)
return A.Ab(b.length,d,a,b)},
Ac(a,b,c,d){var s=A.wI,r=A.A7
switch(b?-1:a){case 0:throw A.a(new A.j6("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
Ad(a,b,c){var s,r
if($.wG==null)$.wG=A.wF("interceptor")
if($.wH==null)$.wH=A.wF("receiver")
s=b.length
r=A.Ac(s,c,a,b)
return r},
wf(a){return A.Ae(a)},
A6(a,b){return A.hB(v.typeUniverse,A.bo(a.a),b)},
wI(a){return a.a},
A7(a){return a.b},
wF(a){var s,r,q,p=new A.eX("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.a(A.J("Field name "+a+" not found.",null))},
uI(a){return v.getIsolateTag(a)},
F6(a,b){var s=$.m
if(s===B.d)return a
return s.fK(a,b)},
za(){return v.G},
G5(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
EJ(a){var s,r,q,p,o,n=$.yY.$1(a),m=$.uE[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.uQ[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.yR.$2(a,n)
if(q!=null){m=$.uE[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.uQ[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.uV(s)
$.uE[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.uQ[n]=s
return s}if(p==="-"){o=A.uV(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.z5(a,s)
if(p==="*")throw A.a(A.vI(n))
if(v.leafTags[n]===true){o=A.uV(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.z5(a,s)},
z5(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.wo(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
uV(a){return J.wo(a,!1,null,!!a.$ib3)},
EL(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.uV(s)
else return J.wo(s,c,null,null)},
Ez(){if(!0===$.wm)return
$.wm=!0
A.EA()},
EA(){var s,r,q,p,o,n,m,l
$.uE=Object.create(null)
$.uQ=Object.create(null)
A.Ey()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.z7.$1(o)
if(n!=null){m=A.EL(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
Ey(){var s,r,q,p,o,n,m=B.aS()
m=A.eP(B.aT,A.eP(B.aU,A.eP(B.a4,A.eP(B.a4,A.eP(B.aV,A.eP(B.aW,A.eP(B.aX(B.a3),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.yY=new A.uN(p)
$.yR=new A.uO(o)
$.z7=new A.uP(n)},
eP(a,b){return a(b)||b},
Cq(a,b){var s
for(s=0;s<a.length;++s)if(!J.A(a[s],b[s]))return!1
return!0},
El(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
vu(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=function(g,h){try{return new RegExp(g,h)}catch(n){return n}}(a,s+r+q+p+f)
if(o instanceof RegExp)return o
throw A.a(A.ak("Illegal RegExp pattern ("+String(o)+")",a,null))},
EZ(a,b,c){var s
if(typeof b=="string")return a.indexOf(b,c)>=0
else if(b instanceof A.fm){s=B.a.a0(a,c)
return b.b.test(s)}else return!J.zU(b,B.a.a0(a,c)).gF(0)},
Eo(a){if(a.indexOf("$",0)>=0)return a.replace(/\$/g,"$$$$")
return a},
z8(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
hM(a,b,c){var s=A.F_(a,b,c)
return s},
F_(a,b,c){var s,r,q
if(b===""){if(a==="")return c
s=a.length
for(r=c,q=0;q<s;++q)r=r+a[q]+c
return r.charCodeAt(0)==0?r:r}if(a.indexOf(b,0)<0)return a
if(a.length<500||c.indexOf("$",0)>=0)return a.split(b).join(c)
return a.replace(new RegExp(A.z8(b),"g"),A.Eo(c))},
yN(a){return a},
zb(a,b,c,d){var s,r,q,p,o,n,m
for(s=b.e7(0,a),s=new A.jG(s.a,s.b,s.c),r=t.lu,q=0,p="";s.m();){o=s.d
if(o==null)o=r.a(o)
n=o.b
m=n.index
p=p+A.q(A.yN(B.a.t(a,q,m)))+A.q(c.$1(o))
q=m+n[0].length}s=p+A.q(A.yN(B.a.a0(a,q)))
return s.charCodeAt(0)==0?s:s},
F0(a,b,c,d){var s=a.indexOf(b,d)
if(s<0)return a
return A.zc(a,s,s+b.length,c)},
zc(a,b,c,d){return a.substring(0,b)+d+a.substring(c)},
ho:function ho(a){this.a=a},
Q:function Q(a,b){this.a=a
this.b=b},
hp:function hp(a,b){this.a=a
this.b=b},
hq:function hq(a,b){this.a=a
this.b=b},
kc:function kc(a,b){this.a=a
this.b=b},
ez:function ez(a,b){this.a=a
this.b=b},
kd:function kd(a,b){this.a=a
this.b=b},
ke:function ke(a,b){this.a=a
this.b=b},
hr:function hr(a,b,c){this.a=a
this.b=b
this.c=c},
kf:function kf(a,b,c){this.a=a
this.b=b
this.c=c},
kg:function kg(a,b,c){this.a=a
this.b=b
this.c=c},
kh:function kh(a,b,c){this.a=a
this.b=b
this.c=c},
ki:function ki(a){this.a=a},
f2:function f2(){},
m_:function m_(a,b,c){this.a=a
this.b=b
this.c=c},
b0:function b0(a,b,c){this.a=a
this.b=b
this.$ti=c},
hf:function hf(a,b){this.a=a
this.$ti=b},
et:function et(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
f3:function f3(){},
f4:function f4(a,b,c){this.a=a
this.b=b
this.$ti=c},
nB:function nB(){},
fk:function fk(a,b){this.a=a
this.$ti=b},
fB:function fB(){},
pB:function pB(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
fA:function fA(){},
iB:function iB(a,b,c){this.a=a
this.b=b
this.c=c},
jq:function jq(a){this.a=a},
iU:function iU(a){this.a=a},
fb:function fb(a,b){this.a=a
this.b=b},
hu:function hu(a){this.a=a
this.b=null},
cT:function cT(){},
lL:function lL(){},
lM:function lM(){},
pp:function pp(){},
oI:function oI(){},
eX:function eX(a,b){this.a=a
this.b=b},
j6:function j6(a){this.a=a},
b4:function b4(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
nJ:function nJ(a){this.a=a},
nM:function nM(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
b5:function b5(a,b){this.a=a
this.$ti=b},
d0:function d0(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
bX:function bX(a,b){this.a=a
this.$ti=b},
b6:function b6(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
aG:function aG(a,b){this.a=a
this.$ti=b},
iI:function iI(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
fn:function fn(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
uN:function uN(a){this.a=a},
uO:function uO(a){this.a=a},
uP:function uP(a){this.a=a},
hn:function hn(){},
k9:function k9(){},
k8:function k8(){},
ka:function ka(){},
kb:function kb(){},
fm:function fm(a,b){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=null},
ex:function ex(a){this.b=a},
jF:function jF(a,b,c){this.a=a
this.b=b
this.c=c},
jG:function jG(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
fK:function fK(a,b){this.a=a
this.c=b},
kt:function kt(a,b,c){this.a=a
this.b=b
this.c=c},
tv:function tv(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
F1(a){throw A.an(A.x1(a),new Error())},
L(){throw A.an(A.x2(""),new Error())},
zd(){throw A.an(A.AQ(""),new Error())},
wq(){throw A.an(A.x1(""),new Error())},
xO(){var s=new A.jP("")
return s.b=s},
qZ(a){var s=new A.jP(a)
return s.b=s},
jP:function jP(a){this.a=a
this.b=null},
kL(a,b,c){},
w8(a){var s,r,q
if(t.iy.b(a))return a
s=J.ab(a)
r=A.b7(s.gk(a),null,!1,t.z)
for(q=0;q<s.gk(a);++q)r[q]=s.i(a,q)
return r},
AY(a){return new DataView(new ArrayBuffer(a))},
x8(a,b,c){var s
A.kL(a,b,c)
s=new DataView(a,b)
return s},
c_(a,b,c){A.kL(a,b,c)
c=B.b.Y(a.byteLength-b,4)
return new Int32Array(a,b,c)},
AZ(a){return new Int8Array(a)},
B_(a,b,c){A.kL(a,b,c)
return new Uint32Array(a,b,c)},
B0(a){return new Uint8Array(a)},
aV(a,b,c){A.kL(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
cg(a,b,c){if(a>>>0!==a||a>=c)throw A.a(A.kS(b,a))},
yq(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.a(A.Em(a,b,c))
return b},
dX:function dX(){},
bF:function bF(){},
fw:function fw(){},
kB:function kB(a){this.a=a},
fv:function fv(){},
dY:function dY(){},
cq:function cq(){},
b8:function b8(){},
iL:function iL(){},
iM:function iM(){},
iN:function iN(){},
iO:function iO(){},
iP:function iP(){},
iQ:function iQ(){},
fx:function fx(){},
fy:function fy(){},
d3:function d3(){},
hi:function hi(){},
hj:function hj(){},
hk:function hk(){},
hl:function hl(){},
vC(a,b){var s=b.c
return s==null?b.c=A.hz(a,"o",[b.x]):s},
xn(a){var s=a.w
if(s===6||s===7)return A.xn(a.x)
return s===11||s===12},
Bi(a){return a.as},
EN(a,b){var s,r=b.length
for(s=0;s<r;++s)if(!a[s].b(b[s]))return!1
return!0},
am(a){return A.tE(v.typeUniverse,a,!1)},
EC(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.cG(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
cG(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.cG(a1,s,a3,a4)
if(r===s)return a2
return A.y3(a1,r,!0)
case 7:s=a2.x
r=A.cG(a1,s,a3,a4)
if(r===s)return a2
return A.y2(a1,r,!0)
case 8:q=a2.y
p=A.eO(a1,q,a3,a4)
if(p===q)return a2
return A.hz(a1,a2.x,p)
case 9:o=a2.x
n=A.cG(a1,o,a3,a4)
m=a2.y
l=A.eO(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.vX(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.eO(a1,j,a3,a4)
if(i===j)return a2
return A.y4(a1,k,i)
case 11:h=a2.x
g=A.cG(a1,h,a3,a4)
f=a2.y
e=A.DO(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.y1(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.eO(a1,d,a3,a4)
o=a2.x
n=A.cG(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.vY(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.a(A.hX("Attempted to substitute unexpected RTI kind "+a0))}},
eO(a,b,c,d){var s,r,q,p,o=b.length,n=A.tN(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.cG(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
DP(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.tN(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.cG(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
DO(a,b,c,d){var s,r=b.a,q=A.eO(a,r,c,d),p=b.b,o=A.eO(a,p,c,d),n=b.c,m=A.DP(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.jY()
s.a=q
s.b=o
s.c=m
return s},
u(a,b){a[v.arrayRti]=b
return a},
kR(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.Eu(s)
return a.$S()}return null},
EB(a,b){var s
if(A.xn(b))if(a instanceof A.cT){s=A.kR(a)
if(s!=null)return s}return A.bo(a)},
bo(a){if(a instanceof A.k)return A.p(a)
if(Array.isArray(a))return A.a5(a)
return A.wb(J.dB(a))},
a5(a){var s=a[v.arrayRti],r=t.dG
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
p(a){var s=a.$ti
return s!=null?s:A.wb(a)},
wb(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.Dd(a,s)},
Dd(a,b){var s=a instanceof A.cT?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.CC(v.typeUniverse,s.name)
b.$ccache=r
return r},
Eu(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.tE(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
uL(a){return A.bm(A.p(a))},
wl(a){var s=A.kR(a)
return A.bm(s==null?A.bo(a):s)},
we(a){var s
if(a instanceof A.hn)return a.ia()
s=a instanceof A.cT?A.kR(a):null
if(s!=null)return s
if(t.aJ.b(a))return J.wz(a).a
if(Array.isArray(a))return A.a5(a)
return A.bo(a)},
bm(a){var s=a.r
return s==null?a.r=new A.tC(a):s},
Ep(a,b){var s,r,q=b,p=q.length
if(p===0)return t.aK
s=A.hB(v.typeUniverse,A.we(q[0]),"@<0>")
for(r=1;r<p;++r)s=A.y6(v.typeUniverse,s,A.we(q[r]))
return A.hB(v.typeUniverse,s,a)},
bp(a){return A.bm(A.tE(v.typeUniverse,a,!1))},
Dc(a){var s=this
s.b=A.DL(s)
return s.b(a)},
DL(a){var s,r,q,p
if(a===t.K)return A.Dl
if(A.dC(a))return A.Dp
s=a.w
if(s===6)return A.Da
if(s===1)return A.yy
if(s===7)return A.Dg
r=A.DK(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.dC)){a.f="$i"+q
if(q==="t")return A.Dj
if(a===t.m)return A.Di
return A.Do}}else if(s===10){p=A.El(a.x,a.y)
return p==null?A.yy:p}return A.D8},
DK(a){if(a.w===8){if(a===t.S)return A.hH
if(a===t.i||a===t.q)return A.Dk
if(a===t.N)return A.Dn
if(a===t.y)return A.kN}return null},
Db(a){var s=this,r=A.D7
if(A.dC(s))r=A.CQ
else if(s===t.K)r=A.CP
else if(A.eR(s)){r=A.D9
if(s===t.I)r=A.w4
else if(s===t.T)r=A.kJ
else if(s===t.o9)r=A.w3
else if(s===t.jh)r=A.CO
else if(s===t.jX)r=A.yn
else if(s===t.mU)r=A.w5}else if(s===t.S)r=A.R
else if(s===t.N)r=A.al
else if(s===t.y)r=A.aY
else if(s===t.q)r=A.CN
else if(s===t.i)r=A.bA
else if(s===t.m)r=A.S
s.a=r
return s.a(a)},
D8(a){var s=this
if(a==null)return A.eR(s)
return A.EH(v.typeUniverse,A.EB(a,s),s)},
Da(a){if(a==null)return!0
return this.x.b(a)},
Do(a){var s,r=this
if(a==null)return A.eR(r)
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.dB(a)[s]},
Dj(a){var s,r=this
if(a==null)return A.eR(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.dB(a)[s]},
Di(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.k)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
yx(a){if(typeof a=="object"){if(a instanceof A.k)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
D7(a){var s=this
if(a==null){if(A.eR(s))return a}else if(s.b(a))return a
throw A.an(A.yt(a,s),new Error())},
D9(a){var s=this
if(a==null||s.b(a))return a
throw A.an(A.yt(a,s),new Error())},
yt(a,b){return new A.hx("TypeError: "+A.xR(a,A.bc(b,null)))},
xR(a,b){return A.ik(a)+": type '"+A.bc(A.we(a),null)+"' is not a subtype of type '"+b+"'"},
bl(a,b){return new A.hx("TypeError: "+A.xR(a,b))},
Dg(a){var s=this
return s.x.b(a)||A.vC(v.typeUniverse,s).b(a)},
Dl(a){return a!=null},
CP(a){if(a!=null)return a
throw A.an(A.bl(a,"Object"),new Error())},
Dp(a){return!0},
CQ(a){return a},
yy(a){return!1},
kN(a){return!0===a||!1===a},
aY(a){if(!0===a)return!0
if(!1===a)return!1
throw A.an(A.bl(a,"bool"),new Error())},
w3(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.an(A.bl(a,"bool?"),new Error())},
bA(a){if(typeof a=="number")return a
throw A.an(A.bl(a,"double"),new Error())},
yn(a){if(typeof a=="number")return a
if(a==null)return a
throw A.an(A.bl(a,"double?"),new Error())},
hH(a){return typeof a=="number"&&Math.floor(a)===a},
R(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.an(A.bl(a,"int"),new Error())},
w4(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.an(A.bl(a,"int?"),new Error())},
Dk(a){return typeof a=="number"},
CN(a){if(typeof a=="number")return a
throw A.an(A.bl(a,"num"),new Error())},
CO(a){if(typeof a=="number")return a
if(a==null)return a
throw A.an(A.bl(a,"num?"),new Error())},
Dn(a){return typeof a=="string"},
al(a){if(typeof a=="string")return a
throw A.an(A.bl(a,"String"),new Error())},
kJ(a){if(typeof a=="string")return a
if(a==null)return a
throw A.an(A.bl(a,"String?"),new Error())},
S(a){if(A.yx(a))return a
throw A.an(A.bl(a,"JSObject"),new Error())},
w5(a){if(a==null)return a
if(A.yx(a))return a
throw A.an(A.bl(a,"JSObject?"),new Error())},
yJ(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.bc(a[q],b)
return s},
DB(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.yJ(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.bc(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
yv(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=", ",a0=null
if(a3!=null){s=a3.length
if(a2==null)a2=A.u([],t.s)
else a0=a2.length
r=a2.length
for(q=s;q>0;--q)a2.push("T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a){o=o+n+a2[a2.length-1-q]
m=a3[q]
l=m.w
if(!(l===2||l===3||l===4||l===5||m===p))o+=" extends "+A.bc(m,a2)}o+=">"}else o=""
p=a1.x
k=a1.y
j=k.a
i=j.length
h=k.b
g=h.length
f=k.c
e=f.length
d=A.bc(p,a2)
for(c="",b="",q=0;q<i;++q,b=a)c+=b+A.bc(j[q],a2)
if(g>0){c+=b+"["
for(b="",q=0;q<g;++q,b=a)c+=b+A.bc(h[q],a2)
c+="]"}if(e>0){c+=b+"{"
for(b="",q=0;q<e;q+=3,b=a){c+=b
if(f[q+1])c+="required "
c+=A.bc(f[q+2],a2)+" "+f[q]}c+="}"}if(a0!=null){a2.toString
a2.length=a0}return o+"("+c+") => "+d},
bc(a,b){var s,r,q,p,o,n,m=a.w
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6){s=a.x
r=A.bc(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(m===7)return"FutureOr<"+A.bc(a.x,b)+">"
if(m===8){p=A.DT(a.x)
o=a.y
return o.length>0?p+("<"+A.yJ(o,b)+">"):p}if(m===10)return A.DB(a,b)
if(m===11)return A.yv(a,b,null)
if(m===12)return A.yv(a.x,b,a.y)
if(m===13){n=a.x
return b[b.length-1-n]}return"?"},
DT(a){var s=A.zg(a)
if(s!=null)return s
return"minified:"+a},
CD(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
CC(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.tE(a,b,!1)
else if(typeof m=="number"){s=m
r=A.hA(a,5,"#")
q=A.tN(s)
for(p=0;p<s;++p)q[p]=r
o=A.hz(a,b,q)
n[b]=o
return o}else return m},
CB(a,b){return A.yk(a.tR,b)},
CA(a,b){return A.yk(a.eT,b)},
tE(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.y5(a,null,b,!1)
r.set(b,s)
return s},
hB(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.y5(a,b,c,!0)
q.set(c,r)
return r},
y6(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.vX(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
y5(a,b,c,d){return A.Co(A.Ci(a,b,c,d))},
cE(a,b){b.a=A.Db
b.b=A.Dc
return b},
hA(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.bt(null,null)
s.w=b
s.as=c
r=A.cE(a,s)
a.eC.set(c,r)
return r},
y3(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.Cy(a,b,r,c)
a.eC.set(r,s)
return s},
Cy(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.dC(b))if(!(b===t.P||b===t.v))if(s!==6)r=s===7&&A.eR(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.bt(null,null)
q.w=6
q.x=b
q.as=c
return A.cE(a,q)},
y2(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.Cw(a,b,r,c)
a.eC.set(r,s)
return s},
Cw(a,b,c,d){var s,r
if(d){s=b.w
if(A.dC(b)||b===t.K)return b
else if(s===1)return A.hz(a,"o",[b])
else if(b===t.P||b===t.v)return t.gK}r=new A.bt(null,null)
r.w=7
r.x=b
r.as=c
return A.cE(a,r)},
Cz(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.bt(null,null)
s.w=13
s.x=b
s.as=q
r=A.cE(a,s)
a.eC.set(q,r)
return r},
hy(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
Cv(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
hz(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.hy(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.bt(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.cE(a,r)
a.eC.set(p,q)
return q},
vX(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.hy(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.bt(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.cE(a,o)
a.eC.set(q,n)
return n},
y4(a,b,c){var s,r,q="+"+(b+"("+A.hy(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.bt(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.cE(a,s)
a.eC.set(q,r)
return r},
y1(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.hy(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.hy(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.Cv(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.bt(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.cE(a,p)
a.eC.set(r,o)
return o},
vY(a,b,c,d){var s,r=b.as+("<"+A.hy(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.Cx(a,b,c,r,d)
a.eC.set(r,s)
return s},
Cx(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.tN(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.cG(a,b,r,0)
m=A.eO(a,c,r,0)
return A.vY(a,n,m,c!==m)}}l=new A.bt(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.cE(a,l)},
Ci(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
Co(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.Ck(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.xY(a,r,l,k,!1)
else if(q===46)r=A.xY(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.ds(a.u,a.e,k.pop()))
break
case 94:k.push(A.Cz(a.u,k.pop()))
break
case 35:k.push(A.hA(a.u,5,"#"))
break
case 64:k.push(A.hA(a.u,2,"@"))
break
case 126:k.push(A.hA(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.Cm(a,k)
break
case 38:A.Cl(a,k)
break
case 63:p=a.u
k.push(A.y3(p,A.ds(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.y2(p,A.ds(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.Cj(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.xZ(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.Cp(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.ds(a.u,a.e,m)},
Ck(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
xY(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.CD(s,o.x)[p]
if(n==null)A.r('No "'+p+'" in "'+A.Bi(o)+'"')
d.push(A.hB(s,o,n))}else d.push(p)
return m},
Cm(a,b){var s,r=a.u,q=A.xX(a,b),p=b.pop()
if(typeof p=="string")b.push(A.hz(r,p,q))
else{s=A.ds(r,a.e,p)
switch(s.w){case 11:b.push(A.vY(r,s,q,a.n))
break
default:b.push(A.vX(r,s,q))
break}}},
Cj(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.xX(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.ds(p,a.e,o)
q=new A.jY()
q.a=s
q.b=n
q.c=m
b.push(A.y1(p,r,q))
return
case-4:b.push(A.y4(p,b.pop(),s))
return
default:throw A.a(A.hX("Unexpected state under `()`: "+A.q(o)))}},
Cl(a,b){var s=b.pop()
if(0===s){b.push(A.hA(a.u,1,"0&"))
return}if(1===s){b.push(A.hA(a.u,4,"1&"))
return}throw A.a(A.hX("Unexpected extended operation "+A.q(s)))},
xX(a,b){var s=b.splice(a.p)
A.xZ(a.u,a.e,s)
a.p=b.pop()
return s},
ds(a,b,c){if(typeof c=="string")return A.hz(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.Cn(a,b,c)}else return c},
xZ(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.ds(a,b,c[s])},
Cp(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.ds(a,b,c[s])},
Cn(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.a(A.hX("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.a(A.hX("Bad index "+c+" for "+b.j(0)))},
EH(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.ay(a,b,null,c,null)
r.set(c,s)}return s},
ay(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.dC(d))return!0
s=b.w
if(s===4)return!0
if(A.dC(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.ay(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.v){if(q===7)return A.ay(a,b,c,d.x,e)
return d===p||d===t.v||q===6}if(d===t.K){if(s===7)return A.ay(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.ay(a,b.x,c,d,e))return!1
return A.ay(a,A.vC(a,b),c,d,e)}if(s===6)return A.ay(a,p,c,d,e)&&A.ay(a,b.x,c,d,e)
if(q===7){if(A.ay(a,b,c,d.x,e))return!0
return A.ay(a,b,c,A.vC(a,d),e)}if(q===6)return A.ay(a,b,c,p,e)||A.ay(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.gY)return!0
o=s===10
if(o&&d===t.lZ)return!0
if(q===12){if(b===t.g)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.ay(a,j,c,i,e)||!A.ay(a,i,e,j,c))return!1}return A.yw(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.yw(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.Dh(a,b,c,d,e)}if(o&&q===10)return A.Dm(a,b,c,d,e)
return!1},
yw(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.ay(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.ay(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.ay(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.ay(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.ay(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
Dh(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.hB(a,b,r[o])
return A.ym(a,p,null,c,d.y,e)}return A.ym(a,b.y,null,c,d.y,e)},
ym(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.ay(a,b[s],d,e[s],f))return!1
return!0},
Dm(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.ay(a,r[s],c,q[s],e))return!1
return!0},
eR(a){var s=a.w,r=!0
if(!(a===t.P||a===t.v))if(!A.dC(a))if(s!==6)r=s===7&&A.eR(a.x)
return r},
dC(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
yk(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
tN(a){return a>0?new Array(a):v.typeUniverse.sEA},
bt:function bt(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
jY:function jY(){this.c=this.b=this.a=null},
tC:function tC(a){this.a=a},
jU:function jU(){},
hx:function hx(a){this.a=a},
BM(){var s,r,q
if(self.scheduleImmediate!=null)return A.DV()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.cI(new A.qF(s),1)).observe(r,{childList:true})
return new A.qE(s,r,q)}else if(self.setImmediate!=null)return A.DW()
return A.DX()},
BN(a){self.scheduleImmediate(A.cI(new A.qG(a),0))},
BO(a){self.setImmediate(A.cI(new A.qH(a),0))},
BP(a){A.vG(B.a7,a)},
vG(a,b){var s=B.b.Y(a.a,1000)
return A.Ct(s<0?0:s,b)},
Ct(a,b){var s=new A.kx(!0)
s.la(a,b)
return s},
Cu(a,b){var s=new A.kx(!1)
s.lb(a,b)
return s},
i(a){return new A.h0(new A.l($.m,a.h("l<0>")),a.h("h0<0>"))},
h(a,b){a.$2(0,null)
b.b=!0
return b.a},
b(a,b){A.yo(a,b)},
f(a,b){b.T(a)},
e(a,b){b.b7(A.E(a),A.I(a))},
yo(a,b){var s,r,q=new A.u1(b),p=new A.u2(b)
if(a instanceof A.l)a.iN(q,p,t.z)
else{s=t.z
if(a instanceof A.l)a.bb(q,p,s)
else{r=new A.l($.m,t._)
r.a=8
r.c=a
r.iN(q,p,s)}}},
d(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.m.cE(new A.uy(s),t.H,t.S,t.z)},
kK(a,b,c){var s,r,q,p
if(b===0){s=c.c
if(s!=null)s.bV(null)
else{s=c.a
s===$&&A.L()
s.n()}return}else if(b===1){s=c.c
if(s!=null){r=A.E(a)
q=A.I(a)
s.ac(new A.a2(r,q))}else{s=A.E(a)
r=A.I(a)
q=c.a
q===$&&A.L()
q.ag(s,r)
c.a.n()}return}if(a instanceof A.he){if(c.c!=null){b.$2(2,null)
return}s=a.b
if(s===0){s=a.a
r=c.a
r===$&&A.L()
r.q(0,s)
A.eT(new A.u_(c,b))
return}else if(s===1){p=a.a
s=c.a
s===$&&A.L()
s.e6(p,!1).aK(new A.u0(c,b),t.P)
return}}A.yo(a,b)},
DN(a){var s=a.a
s===$&&A.L()
return new A.a4(s,A.p(s).h("a4<1>"))},
BQ(a,b){var s=new A.jI(b.h("jI<0>"))
s.l5(a,b)
return s},
Dr(a,b){return A.BQ(a,b)},
Ca(a){return new A.he(a,1)},
xV(a){return new A.he(a,0)},
y0(a,b,c){return 0},
cN(a){var s
if(t.C.b(a)){s=a.gbA()
if(s!=null)return s}return B.t},
AA(a,b){var s=new A.l($.m,b.h("l<0>"))
A.pA(B.a7,new A.n6(a,s))
return s},
dP(a,b){var s,r,q,p,o,n,m,l=null
try{l=a.$0()}catch(q){s=A.E(q)
r=A.I(q)
p=new A.l($.m,b.h("l<0>"))
o=s
n=r
m=A.dx(o,n)
if(m==null)o=new A.a2(o,n==null?A.cN(o):n)
else o=m
p.S(o)
return p}return b.h("o<0>").b(l)?l:A.bM(l,b)},
n5(a,b){var s=a==null?b.a(a):a,r=new A.l($.m,b.h("l<0>"))
r.aE(s)
return r},
n7(a,b){var s,r,q,p,o,n,m,l,k,j,i={},h=null,g=!1,f=new A.l($.m,b.h("l<t<0>>"))
i.a=null
i.b=0
i.c=i.d=null
s=new A.n9(i,h,g,f)
try{for(n=J.Z(a),m=t.P;n.m();){r=n.gp()
q=i.b
r.bb(new A.n8(i,q,f,b,h,g),s,m);++i.b}n=i.b
if(n===0){n=f
n.bV(A.u([],b.h("w<0>")))
return n}i.a=A.b7(n,null,!1,b.h("0?"))}catch(l){p=A.E(l)
o=A.I(l)
if(i.b===0||g){n=f
m=p
k=o
j=A.dx(m,k)
if(j==null)m=new A.a2(m,k==null?A.cN(m):k)
else m=j
n.S(m)
return n}else{i.d=p
i.c=o}}return f},
is(a,b,c,d){var s=new A.n_(d,null,b,c),r=$.m,q=new A.l(r,c.h("l<0>"))
if(r!==B.d)s=r.cE(s,c.h("0/"),t.K,t.l)
a.ck(new A.bj(q,2,null,s,a.$ti.h("@<1>").I(c).h("bj<1,2>")))
return q},
vp(a,b){var s,r,q,p=A.u([],b.h("w<bN<0>>"))
for(s=a.length,r=b.h("bN<0>"),q=0;q<a.length;a.length===s||(0,A.a6)(a),++q)p.push(new A.bN(a[q],r))
if(p.length===0)return A.n5(A.u([],b.h("w<0>")),b.h("t<0>"))
s=new A.l($.m,b.h("l<t<0>>"))
A.xS(p,new A.n0(new A.N(s,b.h("N<t<0>>")),p,b))
return s},
Du(a){return a!=null},
Az(a,b,c){var s=b.h("@<0>").I(c),r=new A.l($.m,s.h("l<+(1,2)>")),q=new A.bN(a.a,b.h("bN<0>")),p=new A.bN(a.b,c.h("bN<0>"))
A.xS(A.u([q,p],t.dB),new A.n4(new A.N(r,s.h("N<+(1,2)>")),q,p))
return r},
xS(a,b){var s,r={},q=r.a=r.b=0,p=new A.ry(r,a,b)
for(s=a.length;q<a.length;a.length===s||(0,A.a6)(a),++q)a[q].mN(p)},
dx(a,b){var s,r,q,p=$.m
if(p===B.d)return null
s=p.jg(a,b)
if(s==null)return null
r=s.a
q=s.b
if(t.C.b(r))A.j0(r,q)
return s},
ax(a,b){var s
if($.m!==B.d){s=A.dx(a,b)
if(s!=null)return s}if(b==null)if(t.C.b(a)){b=a.gbA()
if(b==null){A.j0(a,B.t)
b=B.t}}else b=B.t
else if(t.C.b(a))A.j0(a,b)
return new A.a2(a,b)},
C4(a,b,c){var s=new A.l(b,c.h("l<0>"))
s.a=8
s.c=a
return s},
bM(a,b){var s=new A.l($.m,b.h("l<0>"))
s.a=8
s.c=a
return s},
rE(a,b,c){var s,r,q,p={},o=p.a=a
while(s=o.a,(s&4)!==0){o=o.c
p.a=o}if(o===b){s=A.fH()
b.S(new A.a2(new A.a3(!0,o,null,"Cannot complete a future with itself"),s))
return}r=b.a&1
s=o.a=s|r
if((s&24)===0){q=b.c
b.a=b.a&1|4
b.c=o
o.iq(q)
return}if(!c)if(b.c==null)o=(s&16)===0||r!==0
else o=!1
else o=!0
if(o){q=b.d0()
b.dO(p.a)
A.dq(b,q)
return}b.a^=2
b.b.bQ(new A.rF(p,b))},
dq(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g={},f=g.a=a
for(;;){s={}
r=f.a
q=(r&16)===0
p=!q
if(b==null){if(p&&(r&1)===0){r=f.c
f.b.c7(r.a,r.b)}return}s.a=b
o=b.a
for(f=b;o!=null;f=o,o=n){f.a=null
A.dq(g.a,f)
s.a=o
n=o.a}r=g.a
m=r.c
s.b=p
s.c=m
if(q){l=f.c
l=(l&1)!==0||(l&15)===8}else l=!0
if(l){k=f.b.b
if(p){f=r.b
f=!(f===k||f.gbm()===k.gbm())}else f=!1
if(f){f=g.a
r=f.c
f.b.c7(r.a,r.b)
return}j=$.m
if(j!==k)$.m=k
else j=null
f=s.a.c
if((f&15)===8)new A.rJ(s,g,p).$0()
else if(q){if((f&1)!==0)new A.rI(s,m).$0()}else if((f&2)!==0)new A.rH(g,s).$0()
if(j!=null)$.m=j
f=s.c
if(f instanceof A.l){r=s.a.$ti
r=r.h("o<2>").b(f)||!r.y[1].b(f)}else r=!1
if(r){i=s.a.b
if((f.a&24)!==0){h=i.c
i.c=null
b=i.dX(h)
i.a=f.a&30|i.a&1
i.c=f.c
g.a=f
continue}else A.rE(f,i,!0)
return}}i=s.a.b
h=i.c
i.c=null
b=i.dX(h)
f=s.b
r=s.c
if(!f){i.a=8
i.c=r}else{i.a=i.a&1|16
i.c=r}g.a=i
f=i}},
yD(a,b){if(t.ng.b(a))return b.cE(a,t.z,t.K,t.l)
if(t.mq.b(a))return b.bM(a,t.z,t.K)
throw A.a(A.b_(a,"onError",u.w))},
Dt(){var s,r
for(s=$.eM;s!=null;s=$.eM){$.hJ=null
r=s.b
$.eM=r
if(r==null)$.hI=null
s.a.$0()}},
DM(){$.wc=!0
try{A.Dt()}finally{$.hJ=null
$.wc=!1
if($.eM!=null)$.ws().$1(A.yS())}},
yL(a){var s=new A.jH(a),r=$.hI
if(r==null){$.eM=$.hI=s
if(!$.wc)$.ws().$1(A.yS())}else $.hI=r.b=s},
DJ(a){var s,r,q,p=$.eM
if(p==null){A.yL(a)
$.hJ=$.hI
return}s=new A.jH(a)
r=$.hJ
if(r==null){s.b=p
$.eM=$.hJ=s}else{q=r.b
s.b=q
$.hJ=r.b=s
if(q==null)$.hI=s}},
eT(a){var s,r=null,q=$.m
if(B.d===q){A.ul(r,r,B.d,a)
return}if(B.d===q.gfv().a)s=B.d.gbm()===q.gbm()
else s=!1
if(s){A.ul(r,r,q,q.b_(a,t.H))
return}s=$.m
s.bQ(s.d9(a))},
xs(a,b){var s=null,r=b.h("bL<0>"),q=new A.bL(s,s,s,s,r)
q.N(a)
q.hL()
return new A.a4(q,r.h("a4<1>"))},
Fm(a){return new A.bP(A.bd(a,"stream",t.K))},
bI(a,b,c,d,e,f){return e?new A.cD(b,c,d,a,f.h("cD<0>")):new A.bL(b,c,d,a,f.h("bL<0>"))},
c3(a,b){var s=null
return a?new A.du(s,s,b.h("du<0>")):new A.h1(s,s,b.h("h1<0>"))},
kO(a){var s,r,q
if(a==null)return
try{a.$0()}catch(q){s=A.E(q)
r=A.I(q)
$.m.c7(s,r)}},
C2(a,b,c,d,e,f){var s=$.m,r=e?1:0,q=c!=null?32:0,p=A.jL(s,b,f),o=A.jM(s,c),n=d==null?A.uz():d
return new A.cA(a,p,o,s.b_(n,t.H),s,r|q,f.h("cA<0>"))},
BK(a,b,c){var s=$.m,r=a.geU(),q=a.gdN()
return new A.h_(new A.l(s,t._),b.B(r,!1,a.gf_(),q))},
BL(a){return new A.qC(a)},
jL(a,b,c){var s=b==null?A.DZ():b
return a.bM(s,t.H,c)},
jM(a,b){if(b==null)b=A.E_()
if(t.r.b(b))return a.cE(b,t.z,t.K,t.l)
if(t.i6.b(b))return a.bM(b,t.z,t.K)
throw A.a(A.J(u.y,null))},
Dv(a){},
Dx(a,b){$.m.c7(a,b)},
Dw(){},
xQ(a,b){var s=$.m,r=new A.eo(s,b.h("eo<0>"))
A.eT(r.gim())
if(a!=null)r.c=s.b_(a,t.H)
return r},
DH(a,b,c){var s,r,q,p
try{b.$1(a.$0())}catch(p){s=A.E(p)
r=A.I(p)
q=A.dx(s,r)
if(q!=null)c.$2(q.a,q.b)
else c.$2(s,r)}},
CY(a,b,c){var s=a.u()
if(s!==$.cK())s.J(new A.u5(b,c))
else b.ac(c)},
CZ(a,b){return new A.u4(a,b)},
D_(a,b,c){var s=a.u()
if(s!==$.cK())s.J(new A.u6(b,c))
else b.be(c)},
yl(a,b,c){var s=A.dx(b,c)
if(s!=null){b=s.a
c=s.b}a.a9(b,c)},
pA(a,b){var s=$.m
if(s===B.d)return s.fO(a,b)
return s.fO(a,s.d9(b))},
EV(a,b,c){return A.DI(a,null,b,c)},
DI(a,b,c,d){return $.m.eh(c,b).bv(a,d)},
DF(a,b,c,d,e){A.hK(d,e)},
hK(a,b){A.DJ(new A.ui(a,b))},
uj(a,b,c,d){var s,r=$.m
if(r===c)return d.$0()
$.m=c
s=r
try{r=d.$0()
return r}finally{$.m=s}},
uk(a,b,c,d,e){var s,r=$.m
if(r===c)return d.$1(e)
$.m=c
s=r
try{r=d.$1(e)
return r}finally{$.m=s}},
wd(a,b,c,d,e,f){var s,r=$.m
if(r===c)return d.$2(e,f)
$.m=c
s=r
try{r=d.$2(e,f)
return r}finally{$.m=s}},
yH(a,b,c,d){return d},
yI(a,b,c,d){return d},
yG(a,b,c,d){return d},
DE(a,b,c,d,e){return null},
ul(a,b,c,d){var s,r
if(B.d!==c){s=B.d.gbm()
r=c.gbm()
d=s!==r?c.d9(d):c.fJ(d,t.H)}A.yL(d)},
DD(a,b,c,d,e){e=c.fJ(e,t.H)
return A.vG(d,e)},
DC(a,b,c,d,e){var s
e=c.pZ(e,t.H,t.hU)
s=d.gq6()
return A.Cu(s.pW(0,0)?0:s,e)},
DG(a,b,c,d){A.z6(d)},
yF(a,b,c,d,e){var s,r,q,p,o=null
if(e!=null){s=t.X
r=A.vq(o,o,o,s,s)
r.aa(0,e)}else r=o
s=new A.jR(c.giD(),c.giF(),c.giE(),c.gix(),c.giy(),c.giw(),c.gi0(),c.gfv(),c.ghV(),c.ghU(),c.gir(),c.gi5(),c.gfl(),c.gfF(),c)
if(d!=null){q=d.x
if(q!=null)s.w=new A.kG(s,q)
p=d.a
if(p!=null)s.as=new A.kF(s,p)}if(r!=null)s.at=new A.kH(s,r)
return s},
qF:function qF(a){this.a=a},
qE:function qE(a,b,c){this.a=a
this.b=b
this.c=c},
qG:function qG(a){this.a=a},
qH:function qH(a){this.a=a},
kx:function kx(a){this.a=a
this.b=null
this.c=0},
tB:function tB(a,b){this.a=a
this.b=b},
tA:function tA(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
h0:function h0(a,b){this.a=a
this.b=!1
this.$ti=b},
u1:function u1(a){this.a=a},
u2:function u2(a){this.a=a},
uy:function uy(a){this.a=a},
u_:function u_(a,b){this.a=a
this.b=b},
u0:function u0(a,b){this.a=a
this.b=b},
jI:function jI(a){var _=this
_.a=$
_.b=!1
_.c=null
_.$ti=a},
qJ:function qJ(a){this.a=a},
qK:function qK(a){this.a=a},
qM:function qM(a){this.a=a},
qN:function qN(a,b){this.a=a
this.b=b},
qL:function qL(a,b){this.a=a
this.b=b},
qI:function qI(a){this.a=a},
he:function he(a,b){this.a=a
this.b=b},
kv:function kv(a){var _=this
_.a=a
_.e=_.d=_.c=_.b=null},
eD:function eD(a,b){this.a=a
this.$ti=b},
a2:function a2(a,b){this.a=a
this.b=b},
aq:function aq(a,b){this.a=a
this.$ti=b},
dk:function dk(a,b,c,d,e,f,g){var _=this
_.ay=0
_.CW=_.ch=null
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
c9:function c9(){},
du:function du(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.r=_.f=_.e=_.d=null
_.$ti=c},
tx:function tx(a,b){this.a=a
this.b=b},
tz:function tz(a,b,c){this.a=a
this.b=b
this.c=c},
ty:function ty(a){this.a=a},
h1:function h1(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.r=_.f=_.e=_.d=null
_.$ti=c},
n6:function n6(a,b){this.a=a
this.b=b},
n9:function n9(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
n8:function n8(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
n_:function n_(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
n0:function n0(a,b,c){this.a=a
this.b=b
this.c=c},
n4:function n4(a,b,c){this.a=a
this.b=b
this.c=c},
dZ:function dZ(a,b){this.c=a
this.d=b},
bN:function bN(a,b){var _=this
_.a=a
_.c=_.b=null
_.$ti=b},
rz:function rz(a,b){this.a=a
this.b=b},
rA:function rA(a,b){this.a=a
this.b=b},
ry:function ry(a,b,c){this.a=a
this.b=b
this.c=c},
dl:function dl(){},
aa:function aa(a,b){this.a=a
this.$ti=b},
N:function N(a,b){this.a=a
this.$ti=b},
bj:function bj(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
l:function l(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
rB:function rB(a,b){this.a=a
this.b=b},
rG:function rG(a,b){this.a=a
this.b=b},
rF:function rF(a,b){this.a=a
this.b=b},
rD:function rD(a,b){this.a=a
this.b=b},
rC:function rC(a,b){this.a=a
this.b=b},
rJ:function rJ(a,b,c){this.a=a
this.b=b
this.c=c},
rK:function rK(a,b){this.a=a
this.b=b},
rL:function rL(a){this.a=a},
rI:function rI(a,b){this.a=a
this.b=b},
rH:function rH(a,b){this.a=a
this.b=b},
rM:function rM(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
rN:function rN(a,b,c){this.a=a
this.b=b
this.c=c},
rO:function rO(a,b){this.a=a
this.b=b},
jH:function jH(a){this.a=a
this.b=null},
D:function D(){},
oP:function oP(a,b,c){this.a=a
this.b=b
this.c=c},
oO:function oO(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
oU:function oU(a,b){this.a=a
this.b=b},
oV:function oV(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
oS:function oS(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
oT:function oT(a,b){this.a=a
this.b=b},
oW:function oW(a,b){this.a=a
this.b=b},
oX:function oX(a,b){this.a=a
this.b=b},
oQ:function oQ(a){this.a=a},
oR:function oR(a,b,c){this.a=a
this.b=b
this.c=c},
fJ:function fJ(){},
jk:function jk(){},
cB:function cB(){},
tr:function tr(a){this.a=a},
tq:function tq(a){this.a=a},
kw:function kw(){},
jJ:function jJ(){},
bL:function bL(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
cD:function cD(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
a4:function a4(a,b){this.a=a
this.$ti=b},
cA:function cA(a,b,c,d,e,f,g){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
h_:function h_(a,b){this.a=a
this.b=b},
qC:function qC(a){this.a=a},
qB:function qB(a){this.a=a},
ks:function ks(a,b,c){this.c=a
this.a=b
this.b=c},
aw:function aw(){},
qX:function qX(a,b,c){this.a=a
this.b=b
this.c=c},
qW:function qW(a){this.a=a},
eC:function eC(){},
jT:function jT(){},
bx:function bx(a){this.b=a
this.a=null},
en:function en(a,b){this.b=a
this.c=b
this.a=null},
rq:function rq(){},
ey:function ey(){this.a=0
this.c=this.b=null},
tb:function tb(a,b){this.a=a
this.b=b},
eo:function eo(a,b){var _=this
_.a=1
_.b=a
_.c=null
_.$ti=b},
bP:function bP(a){this.a=null
this.b=a
this.c=!1},
dp:function dp(a){this.$ti=a},
bz:function bz(a,b,c){this.a=a
this.b=b
this.$ti=c},
t9:function t9(a,b){this.a=a
this.b=b},
hh:function hh(a,b,c,d,e){var _=this
_.a=null
_.b=0
_.c=null
_.d=a
_.e=b
_.f=c
_.r=d
_.$ti=e},
u5:function u5(a,b){this.a=a
this.b=b},
u4:function u4(a,b){this.a=a
this.b=b},
u6:function u6(a,b){this.a=a
this.b=b},
bb:function bb(){},
es:function es(a,b,c,d,e,f,g){var _=this
_.w=a
_.x=null
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.r=_.f=null
_.$ti=g},
ce:function ce(a,b,c){this.b=a
this.a=b
this.$ti=c},
aM:function aM(a,b,c){this.b=a
this.a=b
this.$ti=c},
ha:function ha(a){this.a=a},
eA:function eA(a,b,c,d,e,f){var _=this
_.w=$
_.x=null
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=null
_.$ti=f},
c8:function c8(a,b,c){this.a=a
this.b=b
this.$ti=c},
kr:function kr(a){this.a=a},
tX:function tX(a,b){this.a=a
this.b=b},
tZ:function tZ(a,b){this.a=a
this.b=b},
tY:function tY(a,b){this.a=a
this.b=b},
tV:function tV(a,b){this.a=a
this.b=b},
tW:function tW(a,b){this.a=a
this.b=b},
tU:function tU(a,b){this.a=a
this.b=b},
tR:function tR(a,b){this.a=a
this.b=b},
kG:function kG(a,b){this.a=a
this.b=b},
tQ:function tQ(a,b){this.a=a
this.b=b},
tP:function tP(){},
tT:function tT(a,b){this.a=a
this.b=b},
tS:function tS(a,b){this.a=a
this.b=b},
kF:function kF(a,b){this.a=a
this.b=b},
kH:function kH(a,b){this.a=a
this.b=b},
kE:function kE(){},
jR:function jR(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l
_.as=m
_.at=n
_.ax=null
_.ay=o},
rl:function rl(a,b,c){this.a=a
this.b=b
this.c=c},
rk:function rk(a,b){this.a=a
this.b=b},
rm:function rm(a,b,c){this.a=a
this.b=b
this.c=c},
kn:function kn(){},
tg:function tg(a,b,c){this.a=a
this.b=b
this.c=c},
tf:function tf(a,b){this.a=a
this.b=b},
th:function th(a,b,c){this.a=a
this.b=b
this.c=c},
eH:function eH(a){this.a=a},
ui:function ui(a,b){this.a=a
this.b=b},
fY:function fY(a,b,c,d,e,f,g,h,i,j,k,l,m){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k
_.Q=l
_.as=m},
vq(a,b,c,d,e){if(c==null)if(b==null){if(a==null)return new A.cb(d.h("@<0>").I(e).h("cb<1,2>"))
b=A.wh()}else{if(A.yV()===b&&A.yU()===a)return new A.dr(d.h("@<0>").I(e).h("dr<1,2>"))
if(a==null)a=A.wg()}else{if(b==null)b=A.wh()
if(a==null)a=A.wg()}return A.C3(a,b,c,d,e)},
xT(a,b){var s=a[b]
return s===a?null:s},
vU(a,b,c){if(c==null)a[b]=a
else a[b]=c},
vT(){var s=Object.create(null)
A.vU(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
C3(a,b,c,d,e){var s=c!=null?c:new A.rj(d)
return new A.h5(a,b,s,d.h("@<0>").I(e).h("h5<1,2>"))},
vx(a,b,c,d){if(b==null){if(a==null)return new A.b4(c.h("@<0>").I(d).h("b4<1,2>"))
b=A.wh()}else{if(A.yV()===b&&A.yU()===a)return new A.fn(c.h("@<0>").I(d).h("fn<1,2>"))
if(a==null)a=A.wg()}return A.Cg(a,b,null,c,d)},
bE(a,b,c){return A.Er(a,new A.b4(b.h("@<0>").I(c).h("b4<1,2>")))},
T(a,b){return new A.b4(a.h("@<0>").I(b).h("b4<1,2>"))},
Cg(a,b,c,d,e){return new A.hg(a,b,new A.t7(d),d.h("@<0>").I(e).h("hg<1,2>"))},
vy(a){return new A.cc(a.h("cc<0>"))},
bs(a){return new A.cc(a.h("cc<0>"))},
vW(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
Ch(a,b,c){var s=new A.ev(a,b,c.h("ev<0>"))
s.c=a.e
return s},
D1(a,b){return J.A(a,b)},
D2(a){return J.V(a)},
AI(a){var s=new A.kk(a)
if(s.m())return s.gp()
return null},
x3(a,b,c){var s=A.vx(null,null,b,c)
a.ad(0,new A.nN(s,b,c))
return s},
AR(a,b){var s,r,q=A.vy(b)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)q.q(0,b.a(a[r]))
return q},
AS(a,b){var s=A.vy(b)
s.aa(0,a)
return s},
AT(a,b){var s=t.bP
return J.wx(s.a(a),s.a(b))},
nS(a){var s,r
if(A.wn(a))return"{...}"
s=new A.a0("")
try{r={}
$.dy.push(a)
s.a+="{"
r.a=!0
a.ad(0,new A.nT(r,s))
s.a+="}"}finally{$.dy.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
nO(a){return new A.fq(A.b7(A.AU(null),null,!1,a.h("0?")),a.h("fq<0>"))},
AU(a){return 8},
cb:function cb(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
rP:function rP(a){this.a=a},
dr:function dr(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
h5:function h5(a,b,c,d){var _=this
_.f=a
_.r=b
_.w=c
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=d},
rj:function rj(a){this.a=a},
hc:function hc(a,b){this.a=a
this.$ti=b},
jZ:function jZ(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
hg:function hg(a,b,c,d){var _=this
_.w=a
_.x=b
_.y=c
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=d},
t7:function t7(a){this.a=a},
cc:function cc(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
t8:function t8(a){this.a=a
this.c=this.b=null},
ev:function ev(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
nN:function nN(a,b,c){this.a=a
this.b=b
this.c=c},
d1:function d1(a){var _=this
_.b=_.a=0
_.c=null
_.$ti=a},
k5:function k5(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=null
_.d=c
_.e=!1
_.$ti=d},
aH:function aH(){},
y:function y(){},
G:function G(){},
nR:function nR(a){this.a=a},
nT:function nT(a,b){this.a=a
this.b=b},
kA:function kA(){},
fs:function fs(){},
df:function df(a,b){this.a=a
this.$ti=b},
fq:function fq(a,b){var _=this
_.a=a
_.d=_.c=_.b=0
_.$ti=b},
k6:function k6(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.$ti=e},
cu:function cu(){},
ht:function ht(){},
hC:function hC(){},
yA(a,b){var s,r,q,p=null
try{p=JSON.parse(a)}catch(r){s=A.E(r)
q=A.ak(String(s),null,null)
throw A.a(q)}q=A.u7(p)
return q},
u7(a){var s
if(a==null)return null
if(typeof a!="object")return a
if(!Array.isArray(a))return new A.k2(a,Object.create(null))
for(s=0;s<a.length;++s)a[s]=A.u7(a[s])
return a},
CM(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.zD()
else s=new Uint8Array(o)
for(r=J.ab(a),q=0;q<o;++q){p=r.i(a,b+q)
if((p&255)!==p)p=255
s[q]=p}return s},
CL(a,b,c,d){var s=a?$.zC():$.zB()
if(s==null)return null
if(0===c&&d===b.length)return A.yi(s,b)
return A.yi(s,b.subarray(c,d))},
yi(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
wC(a,b,c,d,e,f){if(B.b.aT(f,4)!==0)throw A.a(A.ak("Invalid base64 padding, padded length must be multiple of four, is "+f,a,c))
if(d+e!==f)throw A.a(A.ak("Invalid base64 padding, '=' not at the end",a,b))
if(e>2)throw A.a(A.ak("Invalid base64 padding, more than two '=' characters",a,b))},
BR(a,b,c,d,e,f,g,h){var s,r,q,p,o,n,m,l=h>>>2,k=3-(h&3)
for(s=J.ab(b),r=f.$flags|0,q=c,p=0;q<d;++q){o=s.i(b,q)
p=(p|o)>>>0
l=(l<<8|o)&16777215;--k
if(k===0){n=g+1
r&2&&A.C(f)
f[g]=a.charCodeAt(l>>>18&63)
g=n+1
f[n]=a.charCodeAt(l>>>12&63)
n=g+1
f[g]=a.charCodeAt(l>>>6&63)
g=n+1
f[n]=a.charCodeAt(l&63)
l=0
k=3}}if(p>=0&&p<=255){if(e&&k<3){n=g+1
m=n+1
if(3-k===1){r&2&&A.C(f)
f[g]=a.charCodeAt(l>>>2&63)
f[n]=a.charCodeAt(l<<4&63)
f[m]=61
f[m+1]=61}else{r&2&&A.C(f)
f[g]=a.charCodeAt(l>>>10&63)
f[n]=a.charCodeAt(l>>>4&63)
f[m]=a.charCodeAt(l<<2&63)
f[m+1]=61}return 0}return(l<<2|3-k)>>>0}for(q=c;q<d;){o=s.i(b,q)
if(o<0||o>255)break;++q}throw A.a(A.b_(b,"Not a byte value at index "+q+": 0x"+B.b.p0(s.i(b,q),16),null))},
wP(a){return B.bz.i(0,a.toLowerCase())},
x0(a,b,c){return new A.fo(a,b)},
D3(a){return a.eA()},
Cb(a,b){return new A.t2(a,[],A.Ei())},
Cc(a,b,c){var s,r=new A.a0("")
A.xW(a,r,b,c)
s=r.a
return s.charCodeAt(0)==0?s:s},
xW(a,b,c,d){var s=A.Cb(b,c)
s.eF(a)},
Cd(a,b,c){var s,r,q
for(s=J.ab(a),r=b,q=0;r<c;++r)q=(q|s.i(a,r))>>>0
if(q>=0&&q<=255)return
A.Ce(a,b,c)},
Ce(a,b,c){var s,r,q
for(s=J.ab(a),r=b;r<c;++r){q=s.i(a,r)
if(q<0||q>255)throw A.a(A.ak("Source contains non-Latin-1 characters.",a,r))}},
Cf(a){return new A.eu(a,new A.dt(a))},
yj(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
k2:function k2(a,b){this.a=a
this.b=b
this.c=null},
k3:function k3(a){this.a=a},
t0:function t0(a,b,c){this.b=a
this.c=b
this.a=c},
tL:function tL(){},
tK:function tK(){},
hT:function hT(){},
kz:function kz(){},
hV:function hV(a){this.a=a},
tD:function tD(a,b){this.a=a
this.b=b},
ky:function ky(){},
hU:function hU(a,b){this.a=a
this.b=b},
rt:function rt(a){this.a=a},
ti:function ti(a){this.a=a},
lg:function lg(){},
hZ:function hZ(){},
qO:function qO(){},
qV:function qV(a){this.c=null
this.a=0
this.b=a},
qP:function qP(){},
qD:function qD(a,b){this.a=a
this.b=b},
lx:function lx(){},
jN:function jN(a){this.a=a},
jO:function jO(a,b){this.a=a
this.b=b
this.c=0},
i9:function i9(){},
dm:function dm(a,b){this.a=a
this.b=b},
ia:function ia(){},
ah:function ah(){},
m3:function m3(a){this.a=a},
cY:function cY(){},
mT:function mT(){},
mU:function mU(){},
fo:function fo(a,b){this.a=a
this.b=b},
iC:function iC(a,b){this.a=a
this.b=b},
nK:function nK(){},
iE:function iE(a){this.b=a},
t1:function t1(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
iD:function iD(a){this.a=a},
t3:function t3(){},
t4:function t4(a,b){this.a=a
this.b=b},
t2:function t2(a,b,c){this.c=a
this.a=b
this.b=c},
iF:function iF(){},
iH:function iH(a){this.a=a},
iG:function iG(a,b){this.a=a
this.b=b},
k4:function k4(a){this.a=a},
t5:function t5(a){this.a=a},
nL:function nL(){},
t6:function t6(){},
eu:function eu(a,b){var _=this
_.e=a
_.a=b
_.c=_.b=null
_.d=!1},
jm:function jm(){},
tw:function tw(a,b){this.a=a
this.b=b},
hw:function hw(){},
dt:function dt(a){this.a=a},
kC:function kC(a,b,c){this.a=a
this.b=b
this.c=c},
jx:function jx(){},
jz:function jz(){},
kD:function kD(a){this.b=this.a=0
this.c=a},
tM:function tM(a,b){var _=this
_.d=a
_.b=_.a=0
_.c=b},
jy:function jy(a){this.a=a},
cF:function cF(a){this.a=a
this.b=16
this.c=0},
kI:function kI(){},
BV(a,b){var s,r,q=$.ch(),p=a.length,o=4-p%4
if(o===4)o=0
for(s=0,r=0;r<p;++r){s=s*10+a.charCodeAt(r)-48;++o
if(o===4){q=q.aL(0,$.wt()).dF(0,A.qQ(s))
s=0
o=0}}if(b)return q.bz(0)
return q},
xH(a){if(48<=a&&a<=57)return a-48
return(a|32)-97+10},
BW(a,b,c){var s,r,q,p,o,n,m,l=a.length,k=l-b,j=B.ac.n6(k/4),i=new Uint16Array(j),h=j-1,g=k-h*4
for(s=b,r=0,q=0;q<g;++q,s=p){p=s+1
o=A.xH(a.charCodeAt(s))
if(o>=16)return null
r=r*16+o}n=h-1
i[h]=r
for(;s<l;n=m){for(r=0,q=0;q<4;++q,s=p){p=s+1
o=A.xH(a.charCodeAt(s))
if(o>=16)return null
r=r*16+o}m=n-1
i[n]=r}if(j===1&&i[0]===0)return $.ch()
l=A.bi(j,i)
return new A.aA(l===0?!1:c,i,l)},
BY(a,b){var s,r,q,p,o
if(a==="")return null
s=$.zz().jl(a)
if(s==null)return null
r=s.b
q=r[1]==="-"
p=r[4]
o=r[3]
if(p!=null)return A.BV(p,q)
if(o!=null)return A.BW(o,2,q)
return null},
bi(a,b){for(;;){if(!(a>0&&b[a-1]===0))break;--a}return a},
vR(a,b,c,d){var s,r=new Uint16Array(d),q=c-b
for(s=0;s<q;++s)r[s]=a[b+s]
return r},
qQ(a){var s,r,q,p,o=a<0
if(o){if(a===-9223372036854776e3){s=new Uint16Array(4)
s[3]=32768
r=A.bi(4,s)
return new A.aA(r!==0,s,r)}a=-a}if(a<65536){s=new Uint16Array(1)
s[0]=a
r=A.bi(1,s)
return new A.aA(r===0?!1:o,s,r)}if(a<=4294967295){s=new Uint16Array(2)
s[0]=a&65535
s[1]=B.b.a2(a,16)
r=A.bi(2,s)
return new A.aA(r===0?!1:o,s,r)}r=B.b.Y(B.b.gj4(a)-1,16)+1
s=new Uint16Array(r)
for(q=0;a!==0;q=p){p=q+1
s[q]=a&65535
a=B.b.Y(a,65536)}r=A.bi(r,s)
return new A.aA(r===0?!1:o,s,r)},
vS(a,b,c,d){var s,r,q
if(b===0)return 0
if(c===0&&d===a)return b
for(s=b-1,r=d.$flags|0;s>=0;--s){q=a[s]
r&2&&A.C(d)
d[s+c]=q}for(s=c-1;s>=0;--s){r&2&&A.C(d)
d[s]=0}return b+c},
BU(a,b,c,d){var s,r,q,p,o,n=B.b.Y(c,16),m=B.b.aT(c,16),l=16-m,k=B.b.cN(1,l)-1
for(s=b-1,r=d.$flags|0,q=0;s>=0;--s){p=a[s]
o=B.b.cO(p,l)
r&2&&A.C(d)
d[s+n+1]=(o|q)>>>0
q=B.b.cN((p&k)>>>0,m)}r&2&&A.C(d)
d[n]=q},
xI(a,b,c,d){var s,r,q,p,o=B.b.Y(c,16)
if(B.b.aT(c,16)===0)return A.vS(a,b,o,d)
s=b+o+1
A.BU(a,b,c,d)
for(r=d.$flags|0,q=o;--q,q>=0;){r&2&&A.C(d)
d[q]=0}p=s-1
return d[p]===0?p:s},
BX(a,b,c,d){var s,r,q,p,o=B.b.Y(c,16),n=B.b.aT(c,16),m=16-n,l=B.b.cN(1,n)-1,k=B.b.cO(a[o],n),j=b-o-1
for(s=d.$flags|0,r=0;r<j;++r){q=a[r+o+1]
p=B.b.cN((q&l)>>>0,m)
s&2&&A.C(d)
d[r]=(p|k)>>>0
k=B.b.cO(q,n)}s&2&&A.C(d)
d[j]=k},
qR(a,b,c,d){var s,r=b-d
if(r===0)for(s=b-1;s>=0;--s){r=a[s]-c[s]
if(r!==0)return r}return r},
BS(a,b,c,d,e){var s,r,q
for(s=e.$flags|0,r=0,q=0;q<d;++q){r+=a[q]+c[q]
s&2&&A.C(e)
e[q]=r&65535
r=B.b.a2(r,16)}for(q=d;q<b;++q){r+=a[q]
s&2&&A.C(e)
e[q]=r&65535
r=B.b.a2(r,16)}s&2&&A.C(e)
e[b]=r},
jK(a,b,c,d,e){var s,r,q
for(s=e.$flags|0,r=0,q=0;q<d;++q){r+=a[q]-c[q]
s&2&&A.C(e)
e[q]=r&65535
r=0-(B.b.a2(r,16)&1)}for(q=d;q<b;++q){r+=a[q]
s&2&&A.C(e)
e[q]=r&65535
r=0-(B.b.a2(r,16)&1)}},
xN(a,b,c,d,e,f){var s,r,q,p,o,n
if(a===0)return
for(s=d.$flags|0,r=0;--f,f>=0;e=o,c=q){q=c+1
p=a*b[c]+d[e]+r
o=e+1
s&2&&A.C(d)
d[e]=p&65535
r=B.b.Y(p,65536)}for(;r!==0;e=o){n=d[e]+r
o=e+1
s&2&&A.C(d)
d[e]=n&65535
r=B.b.Y(n,65536)}},
BT(a,b,c){var s,r=b[c]
if(r===a)return 65535
s=B.b.hB((r<<16|b[c-1])>>>0,a)
if(s>65535)return 65535
return s},
Ex(a){return A.kT(a)},
wS(a){var s=!0
s=typeof a=="string"
if(s)A.wR(a)},
wR(a){throw A.a(A.b_(a,"object","Expandos are not allowed on strings, numbers, bools, records or null"))},
jX(a,b){var s=$.zA()
s=s==null?null:new s(A.cI(A.F6(a,b),1))
return new A.jW(s,b.h("jW<0>"))},
z_(a){var s=A.vA(a,null)
if(s!=null)return s
throw A.a(A.ak(a,null,null))},
Av(a,b){a=A.an(a,new Error())
a.stack=b.j(0)
throw a},
b7(a,b,c,d){var s,r=c?J.AK(a,d):J.vs(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
AW(a,b,c){var s,r=A.u([],c.h("w<0>"))
for(s=J.Z(a);s.m();)r.push(s.gp())
r.$flags=1
return r},
ap(a,b){var s,r
if(Array.isArray(a))return A.u(a.slice(0),b.h("w<0>"))
s=A.u([],b.h("w<0>"))
for(r=J.Z(a);r.m();)s.push(r.gp())
return s},
nP(a,b){var s=A.AW(a,!1,b)
s.$flags=3
return s},
bJ(a,b,c){var s,r,q,p,o
A.aI(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.a(A.ac(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.xl(b>0||c<o?p.slice(b,c):p)}if(t.Z.b(a))return A.Br(a,b,c)
if(r)a=J.wB(a,c)
if(b>0)a=J.l1(a,b)
s=A.ap(a,t.S)
return A.xl(s)},
Br(a,b,c){var s=a.length
if(b>=s)return""
return A.B8(a,b,c==null||c>s?s:c)},
au(a,b){return new A.fm(a,A.vu(a,!1,b,!1,!1,""))},
Ew(a,b){return a==null?b==null:a===b},
vE(a,b,c){var s=J.Z(b)
if(!s.m())return a
if(c.length===0){do a+=A.q(s.gp())
while(s.m())}else{a+=A.q(s.gp())
while(s.m())a=a+c+A.q(s.gp())}return a},
vJ(){var s,r,q=A.B3()
if(q==null)throw A.a(A.P("'Uri.base' is not supported"))
s=$.xF
if(s!=null&&q===$.xE)return s
r=A.dg(q)
$.xF=r
$.xE=q
return r},
fH(){return A.I(new Error())},
mP(a){var s=B.b.aT(a,1000),r=B.b.Y(a-s,1000)
if(r<-864e13||r>864e13)A.r(A.ac(r,-864e13,864e13,"millisecondsSinceEpoch",null))
if(r===864e13&&s!==0)A.r(A.b_(s,"microsecond","Time including microseconds is outside valid range"))
A.bd(!1,"isUtc",t.y)
return new A.bT(r,s,!1)},
Aq(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
wO(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
ih(a){if(a>=10)return""+a
return"0"+a},
mS(a,b){return new A.b1(a+1000*b)},
mV(a,b){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(q.b===b)return q}throw A.a(A.b_(b,"name","No enum value with that name"))},
ik(a){if(typeof a=="number"||A.kN(a)||a==null)return J.be(a)
if(typeof a=="string")return JSON.stringify(a)
return A.xk(a)},
il(a,b){A.bd(a,"error",t.K)
A.bd(b,"stackTrace",t.l)
A.Av(a,b)},
hX(a){return new A.hW(a)},
J(a,b){return new A.a3(!1,null,b,a)},
b_(a,b,c){return new A.a3(!0,a,b,c)},
hS(a,b){return a},
az(a){var s=null
return new A.e1(s,s,!1,s,s,a)},
of(a,b){return new A.e1(null,null,!0,a,b,"Value not in range")},
ac(a,b,c,d,e){return new A.e1(b,c,!0,a,d,"Invalid value")},
xm(a,b,c,d){if(a<b||a>c)throw A.a(A.ac(a,b,c,d,null))
return a},
aJ(a,b,c){if(0>a||a>c)throw A.a(A.ac(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.a(A.ac(b,a,c,"end",null))
return b}return c},
aI(a,b){if(a<0)throw A.a(A.ac(a,0,null,b,null))
return a},
wX(a,b){var s=b.b
return new A.fj(s,!0,a,null,"Index out of range")},
iu(a,b,c,d,e){return new A.fj(b,!0,a,e,"Index out of range")},
AF(a,b,c,d,e){if(0>a||a>=b)throw A.a(A.iu(a,b,c,d,e==null?"index":e))
return a},
P(a){return new A.fR(a)},
vI(a){return new A.jp(a)},
z(a){return new A.aX(a)},
ao(a){return new A.ib(a)},
wQ(a){return new A.jV(a)},
ak(a,b,c){return new A.aU(a,b,c)},
AJ(a,b,c){var s,r
if(A.wn(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.u([],t.s)
$.dy.push(a)
try{A.Dq(a,s)}finally{$.dy.pop()}r=A.vE(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
nH(a,b,c){var s,r
if(A.wn(a))return b+"..."+c
s=new A.a0(b)
$.dy.push(a)
try{r=s
r.a=A.vE(r.a,a,", ")}finally{$.dy.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
Dq(a,b){var s,r,q,p,o,n,m,l=a.gA(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.m())return
s=A.q(l.gp())
b.push(s)
k+=s.length+2;++j}if(!l.m()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gp();++j
if(!l.m()){if(j<=4){b.push(A.q(p))
return}r=A.q(p)
q=b.pop()
k+=r.length+2}else{o=l.gp();++j
for(;l.m();p=o,o=n){n=l.gp();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
k-=b.pop().length+2;--j}b.push("...")
return}}q=A.q(p)
r=A.q(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)b.push(m)
b.push(q)
b.push(r)},
x6(a,b,c,d,e){return new A.cR(a,b.h("@<0>").I(c).I(d).I(e).h("cR<1,2,3,4>"))},
c0(a,b,c,d,e,f){var s
if(B.e===c)return A.xx(J.V(a),J.V(b),$.eU())
if(B.e===d){s=J.V(a)
b=J.V(b)
c=J.V(c)
return A.fN(A.av(A.av(A.av($.eU(),s),b),c))}if(B.e===e){s=J.V(a)
b=J.V(b)
c=J.V(c)
d=J.V(d)
return A.fN(A.av(A.av(A.av(A.av($.eU(),s),b),c),d))}if(B.e===f){s=J.V(a)
b=J.V(b)
c=J.V(c)
d=J.V(d)
e=J.V(e)
return A.fN(A.av(A.av(A.av(A.av(A.av($.eU(),s),b),c),d),e))}s=J.V(a)
b=J.V(b)
c=J.V(c)
d=J.V(d)
e=J.V(e)
f=J.V(f)
f=A.fN(A.av(A.av(A.av(A.av(A.av(A.av($.eU(),s),b),c),d),e),f))
return f},
B1(a){var s,r,q=$.eU()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)q=A.av(q,J.V(a[r]))
return A.fN(q)},
B2(a){var s,r,q,p,o
for(s=a.gA(a),r=0,q=0;s.m();){p=J.V(s.gp())
o=((p^p>>>16)>>>0)*569420461>>>0
o=((o^o>>>15)>>>0)*3545902487>>>0
r=r+((o^o>>>15)>>>0)&1073741823;++q}return A.xx(r,q,0)},
v6(a){var s=A.q(a),r=$.Dy
if(r==null)A.z6(s)
else r.$1(s)},
dg(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=null,a4=a5.length
if(a4>=5){s=((a5.charCodeAt(4)^58)*3|a5.charCodeAt(0)^100|a5.charCodeAt(1)^97|a5.charCodeAt(2)^116|a5.charCodeAt(3)^97)>>>0
if(s===0)return A.xD(a4<a4?B.a.t(a5,0,a4):a5,5,a3).gjT()
else if(s===32)return A.xD(B.a.t(a5,5,a4),0,a3).gjT()}r=A.b7(8,0,!1,t.S)
r[0]=0
r[1]=-1
r[2]=-1
r[7]=-1
r[3]=0
r[4]=0
r[5]=a4
r[6]=a4
if(A.yK(a5,0,a4,0,r)>=14)r[7]=a4
q=r[1]
if(q>=0)if(A.yK(a5,0,q,20,r)===20)r[7]=q
p=r[2]+1
o=r[3]
n=r[4]
m=r[5]
l=r[6]
if(l<m)m=l
if(n<p)n=m
else if(n<=q)n=q+1
if(o<p)o=n
k=r[7]<0
j=a3
if(k){k=!1
if(!(p>q+3)){i=o>0
if(!(i&&o+1===n)){if(!B.a.R(a5,"\\",n))if(p>0)h=B.a.R(a5,"\\",p-1)||B.a.R(a5,"\\",p-2)
else h=!1
else h=!0
if(!h){if(!(m<a4&&m===n+2&&B.a.R(a5,"..",n)))h=m>n+2&&B.a.R(a5,"/..",m-3)
else h=!0
if(!h)if(q===4){if(B.a.R(a5,"file",0)){if(p<=0){if(!B.a.R(a5,"/",n)){g="file:///"
s=3}else{g="file://"
s=2}a5=g+B.a.t(a5,n,a4)
m+=s
l+=s
a4=a5.length
p=7
o=7
n=7}else if(n===m){++l
f=m+1
a5=B.a.c9(a5,n,m,"/");++a4
m=f}j="file"}else if(B.a.R(a5,"http",0)){if(i&&o+3===n&&B.a.R(a5,"80",o+1)){l-=3
e=n-3
m-=3
a5=B.a.c9(a5,o,n,"")
a4-=3
n=e}j="http"}}else if(q===5&&B.a.R(a5,"https",0)){if(i&&o+4===n&&B.a.R(a5,"443",o+1)){l-=4
e=n-4
m-=4
a5=B.a.c9(a5,o,n,"")
a4-=3
n=e}j="https"}k=!h}}}}if(k)return new A.bk(a4<a5.length?B.a.t(a5,0,a4):a5,q,p,o,n,m,l,j)
if(j==null)if(q>0)j=A.w_(a5,0,q)
else{if(q===0)A.eF(a5,0,"Invalid empty scheme")
j=""}d=a3
if(p>0){c=q+3
b=c<p?A.ye(a5,c,p-1):""
a=A.yb(a5,p,o,!1)
i=o+1
if(i<n){a0=A.vA(B.a.t(a5,i,n),a3)
d=A.tJ(a0==null?A.r(A.ak("Invalid port",a5,i)):a0,j)}}else{a=a3
b=""}a1=A.yc(a5,n,m,a3,j,a!=null)
a2=m<l?A.yd(a5,m+1,l,a3):a3
return A.hE(j,b,a,d,a1,a2,l<a4?A.ya(a5,l+1,a4):a3)},
BF(a){return A.w2(a,0,a.length,B.l,!1)},
jw(a,b,c){throw A.a(A.ak("Illegal IPv4 address, "+a,b,c))},
BC(a,b,c,d,e){var s,r,q,p,o,n,m,l,k="invalid character"
for(s=d.$flags|0,r=b,q=r,p=0,o=0;;){n=q>=c?0:a.charCodeAt(q)
m=n^48
if(m<=9){if(o!==0||q===r){o=o*10+m
if(o<=255){++q
continue}A.jw("each part must be in the range 0..255",a,r)}A.jw("parts must not have leading zeros",a,r)}if(q===r){if(q===c)break
A.jw(k,a,q)}l=p+1
s&2&&A.C(d)
d[e+p]=o
if(n===46){if(l<4){++q
p=l
r=q
o=0
continue}break}if(q===c){if(l===4)return
break}A.jw(k,a,q)
p=l}A.jw("IPv4 address should contain exactly 4 parts",a,q)},
BD(a,b,c){var s
if(b===c)throw A.a(A.ak("Empty IP address",a,b))
if(a.charCodeAt(b)===118){s=A.BE(a,b,c)
if(s!=null)throw A.a(s)
return!1}A.xG(a,b,c)
return!0},
BE(a,b,c){var s,r,q,p,o="Missing hex-digit in IPvFuture address";++b
for(s=b;;s=r){if(s<c){r=s+1
q=a.charCodeAt(s)
if((q^48)<=9)continue
p=q|32
if(p>=97&&p<=102)continue
if(q===46){if(r-1===b)return new A.aU(o,a,r)
s=r
break}return new A.aU("Unexpected character",a,r-1)}if(s-1===b)return new A.aU(o,a,s)
return new A.aU("Missing '.' in IPvFuture address",a,s)}if(s===c)return new A.aU("Missing address in IPvFuture address, host, cursor",null,null)
for(;;){if((u.S.charCodeAt(a.charCodeAt(s))&16)!==0){++s
if(s<c)continue
return null}return new A.aU("Invalid IPvFuture address character",a,s)}},
xG(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a="an address must contain at most 8 parts",a0=new A.pO(a1)
if(a3-a2<2)a0.$2("address is too short",null)
s=new Uint8Array(16)
r=-1
q=0
if(a1.charCodeAt(a2)===58)if(a1.charCodeAt(a2+1)===58){p=a2+2
o=p
r=0
q=1}else{a0.$2("invalid start colon",a2)
p=a2
o=p}else{p=a2
o=p}for(n=0,m=!0;;){l=p>=a3?0:a1.charCodeAt(p)
A:{k=l^48
j=!1
if(k<=9)i=k
else{h=l|32
if(h>=97&&h<=102)i=h-87
else break A
m=j}if(p<o+4){n=n*16+i;++p
continue}a0.$2("an IPv6 part can contain a maximum of 4 hex digits",o)}if(p>o){if(l===46){if(m){if(q<=6){A.BC(a1,o,a3,s,q*2)
q+=2
p=a3
break}a0.$2(a,o)}break}g=q*2
s[g]=B.b.a2(n,8)
s[g+1]=n&255;++q
if(l===58){if(q<8){++p
o=p
n=0
m=!0
continue}a0.$2(a,p)}break}if(l===58){if(r<0){f=q+1;++p
r=q
q=f
o=p
continue}a0.$2("only one wildcard `::` is allowed",p)}if(r!==q-1)a0.$2("missing part",p)
break}if(p<a3)a0.$2("invalid character",p)
if(q<8){if(r<0)a0.$2("an address without a wildcard must contain exactly 8 parts",a3)
e=r+1
d=q-e
if(d>0){c=e*2
b=16-d*2
B.f.X(s,b,16,s,c)
B.f.fT(s,c,b,0)}}return s},
hE(a,b,c,d,e,f,g){return new A.hD(a,b,c,d,e,f,g)},
y7(a){if(a==="http")return 80
if(a==="https")return 443
return 0},
eF(a,b,c){throw A.a(A.ak(c,a,b))},
CF(a,b){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(B.a.U(q,"/")){s=A.P("Illegal path character "+q)
throw A.a(s)}}},
tJ(a,b){if(a!=null&&a===A.y7(b))return null
return a},
yb(a,b,c,d){var s,r,q,p,o,n,m,l
if(a==null)return null
if(b===c)return""
if(a.charCodeAt(b)===91){s=c-1
if(a.charCodeAt(s)!==93)A.eF(a,b,"Missing end `]` to match `[` in host")
r=b+1
q=""
if(a.charCodeAt(r)!==118){p=A.CG(a,r,s)
if(p<s){o=p+1
q=A.yh(a,B.a.R(a,"25",o)?p+3:o,s,"%25")}s=p}n=A.BD(a,r,s)
m=B.a.t(a,r,s)
return"["+(n?m.toLowerCase():m)+q+"]"}for(l=b;l<c;++l)if(a.charCodeAt(l)===58){s=B.a.bn(a,"%",b)
s=s>=b&&s<c?s:c
if(s<c){o=s+1
q=A.yh(a,B.a.R(a,"25",o)?s+3:o,c,"%25")}else q=""
A.xG(a,b,s)
return"["+B.a.t(a,b,s)+q+"]"}return A.CJ(a,b,c)},
CG(a,b,c){var s=B.a.bn(a,"%",b)
return s>=b&&s<c?s:c},
yh(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i=d!==""?new A.a0(d):null
for(s=b,r=s,q=!0;s<c;){p=a.charCodeAt(s)
if(p===37){o=A.w0(a,s,!0)
n=o==null
if(n&&q){s+=3
continue}if(i==null)i=new A.a0("")
m=i.a+=B.a.t(a,r,s)
if(n)o=B.a.t(a,s,s+3)
else if(o==="%")A.eF(a,s,"ZoneID should not contain % anymore")
i.a=m+o
s+=3
r=s
q=!0}else if(p<127&&(u.S.charCodeAt(p)&1)!==0){if(q&&65<=p&&90>=p){if(i==null)i=new A.a0("")
if(r<s){i.a+=B.a.t(a,r,s)
r=s}q=!1}++s}else{l=1
if((p&64512)===55296&&s+1<c){k=a.charCodeAt(s+1)
if((k&64512)===56320){p=65536+((p&1023)<<10)+(k&1023)
l=2}}j=B.a.t(a,r,s)
if(i==null){i=new A.a0("")
n=i}else n=i
n.a+=j
m=A.vZ(p)
n.a+=m
s+=l
r=s}}if(i==null)return B.a.t(a,b,c)
if(r<c){j=B.a.t(a,r,c)
i.a+=j}n=i.a
return n.charCodeAt(0)==0?n:n},
CJ(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=u.S
for(s=b,r=s,q=null,p=!0;s<c;){o=a.charCodeAt(s)
if(o===37){n=A.w0(a,s,!0)
m=n==null
if(m&&p){s+=3
continue}if(q==null)q=new A.a0("")
l=B.a.t(a,r,s)
if(!p)l=l.toLowerCase()
k=q.a+=l
j=3
if(m)n=B.a.t(a,s,s+3)
else if(n==="%"){n="%25"
j=1}q.a=k+n
s+=j
r=s
p=!0}else if(o<127&&(h.charCodeAt(o)&32)!==0){if(p&&65<=o&&90>=o){if(q==null)q=new A.a0("")
if(r<s){q.a+=B.a.t(a,r,s)
r=s}p=!1}++s}else if(o<=93&&(h.charCodeAt(o)&1024)!==0)A.eF(a,s,"Invalid character")
else{j=1
if((o&64512)===55296&&s+1<c){i=a.charCodeAt(s+1)
if((i&64512)===56320){o=65536+((o&1023)<<10)+(i&1023)
j=2}}l=B.a.t(a,r,s)
if(!p)l=l.toLowerCase()
if(q==null){q=new A.a0("")
m=q}else m=q
m.a+=l
k=A.vZ(o)
m.a+=k
s+=j
r=s}}if(q==null)return B.a.t(a,b,c)
if(r<c){l=B.a.t(a,r,c)
if(!p)l=l.toLowerCase()
q.a+=l}m=q.a
return m.charCodeAt(0)==0?m:m},
w_(a,b,c){var s,r,q
if(b===c)return""
if(!A.y9(a.charCodeAt(b)))A.eF(a,b,"Scheme not starting with alphabetic character")
for(s=b,r=!1;s<c;++s){q=a.charCodeAt(s)
if(!(q<128&&(u.S.charCodeAt(q)&8)!==0))A.eF(a,s,"Illegal scheme character")
if(65<=q&&q<=90)r=!0}a=B.a.t(a,b,c)
return A.CE(r?a.toLowerCase():a)},
CE(a){if(a==="http")return"http"
if(a==="file")return"file"
if(a==="https")return"https"
if(a==="package")return"package"
return a},
ye(a,b,c){if(a==null)return""
return A.hF(a,b,c,16,!1,!1)},
yc(a,b,c,d,e,f){var s,r=e==="file",q=r||f
if(a==null)return r?"/":""
else s=A.hF(a,b,c,128,!0,!0)
if(s.length===0){if(r)return"/"}else if(q&&!B.a.K(s,"/"))s="/"+s
return A.CI(s,e,f)},
CI(a,b,c){var s=b.length===0
if(s&&!c&&!B.a.K(a,"/")&&!B.a.K(a,"\\"))return A.w1(a,!s||c)
return A.dw(a)},
yd(a,b,c,d){if(a!=null)return A.hF(a,b,c,256,!0,!1)
return null},
ya(a,b,c){if(a==null)return null
return A.hF(a,b,c,256,!0,!1)},
w0(a,b,c){var s,r,q,p,o,n=b+2
if(n>=a.length)return"%"
s=a.charCodeAt(b+1)
r=a.charCodeAt(n)
q=A.uM(s)
p=A.uM(r)
if(q<0||p<0)return"%"
o=q*16+p
if(o<127&&(u.S.charCodeAt(o)&1)!==0)return A.aR(c&&65<=o&&90>=o?(o|32)>>>0:o)
if(s>=97||r>=97)return B.a.t(a,b,b+3).toUpperCase()
return null},
vZ(a){var s,r,q,p,o,n="0123456789ABCDEF"
if(a<=127){s=new Uint8Array(3)
s[0]=37
s[1]=n.charCodeAt(a>>>4)
s[2]=n.charCodeAt(a&15)}else{if(a>2047)if(a>65535){r=240
q=4}else{r=224
q=3}else{r=192
q=2}s=new Uint8Array(3*q)
for(p=0;--q,q>=0;r=128){o=B.b.mB(a,6*q)&63|r
s[p]=37
s[p+1]=n.charCodeAt(o>>>4)
s[p+2]=n.charCodeAt(o&15)
p+=3}}return A.bJ(s,0,null)},
hF(a,b,c,d,e,f){var s=A.yg(a,b,c,d,e,f)
return s==null?B.a.t(a,b,c):s},
yg(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=null,i=u.S
for(s=!e,r=b,q=r,p=j;r<c;){o=a.charCodeAt(r)
if(o<127&&(i.charCodeAt(o)&d)!==0)++r
else{n=1
if(o===37){m=A.w0(a,r,!1)
if(m==null){r+=3
continue}if("%"===m)m="%25"
else n=3}else if(o===92&&f)m="/"
else if(s&&o<=93&&(i.charCodeAt(o)&1024)!==0){A.eF(a,r,"Invalid character")
n=j
m=n}else{if((o&64512)===55296){l=r+1
if(l<c){k=a.charCodeAt(l)
if((k&64512)===56320){o=65536+((o&1023)<<10)+(k&1023)
n=2}}}m=A.vZ(o)}if(p==null){p=new A.a0("")
l=p}else l=p
l.a=(l.a+=B.a.t(a,q,r))+m
r+=n
q=r}}if(p==null)return j
if(q<c){s=B.a.t(a,q,c)
p.a+=s}s=p.a
return s.charCodeAt(0)==0?s:s},
yf(a){if(B.a.K(a,"."))return!0
return B.a.cw(a,"/.")!==-1},
dw(a){var s,r,q,p,o,n
if(!A.yf(a))return a
s=A.u([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(n===".."){if(s.length!==0){s.pop()
if(s.length===0)s.push("")}p=!0}else{p="."===n
if(!p)s.push(n)}}if(p)s.push("")
return B.c.bp(s,"/")},
w1(a,b){var s,r,q,p,o,n
if(!A.yf(a))return!b?A.y8(a):a
s=A.u([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(".."===n){if(s.length!==0&&B.c.gaQ(s)!=="..")s.pop()
else s.push("..")
p=!0}else{p="."===n
if(!p)s.push(n.length===0&&s.length===0?"./":n)}}if(s.length===0)return"./"
if(p)s.push("")
if(!b)s[0]=A.y8(s[0])
return B.c.bp(s,"/")},
y8(a){var s,r,q=a.length
if(q>=2&&A.y9(a.charCodeAt(0)))for(s=1;s<q;++s){r=a.charCodeAt(s)
if(r===58)return B.a.t(a,0,s)+"%3A"+B.a.a0(a,s+1)
if(r>127||(u.S.charCodeAt(r)&8)===0)break}return a},
CK(a,b){if(a.el("package")&&a.c==null)return A.yM(b,0,b.length)
return-1},
CH(a,b){var s,r,q
for(s=0,r=0;r<2;++r){q=a.charCodeAt(b+r)
if(48<=q&&q<=57)s=s*16+q-48
else{q|=32
if(97<=q&&q<=102)s=s*16+q-87
else throw A.a(A.J("Invalid URL encoding",null))}}return s},
w2(a,b,c,d,e){var s,r,q,p,o=b
for(;;){if(!(o<c)){s=!0
break}r=a.charCodeAt(o)
if(r<=127)q=r===37
else q=!0
if(q){s=!1
break}++o}if(s)if(B.l===d)return B.a.t(a,b,c)
else p=new A.br(B.a.t(a,b,c))
else{p=A.u([],t.t)
for(q=a.length,o=b;o<c;++o){r=a.charCodeAt(o)
if(r>127)throw A.a(A.J("Illegal percent encoding in URI",null))
if(r===37){if(o+3>q)throw A.a(A.J("Truncated URI",null))
p.push(A.CH(a,o+1))
o+=2}else p.push(r)}}return d.aI(p)},
y9(a){var s=a|32
return 97<=s&&s<=122},
xD(a,b,c){var s,r,q,p,o,n,m,l,k="Invalid MIME type",j=A.u([b-1],t.t)
for(s=a.length,r=b,q=-1,p=null;r<s;++r){p=a.charCodeAt(r)
if(p===44||p===59)break
if(p===47){if(q<0){q=r
continue}throw A.a(A.ak(k,a,r))}}if(q<0&&r>b)throw A.a(A.ak(k,a,r))
while(p!==44){j.push(r);++r
for(o=-1;r<s;++r){p=a.charCodeAt(r)
if(p===61){if(o<0)o=r}else if(p===59||p===44)break}if(o>=0)j.push(o)
else{n=B.c.gaQ(j)
if(p!==44||r!==n+7||!B.a.R(a,"base64",n+1))throw A.a(A.ak("Expecting '='",a,r))
break}}j.push(r)
m=r+1
if((j.length&1)===1)a=B.aN.oE(a,m,s)
else{l=A.yg(a,m,s,256,!0,!1)
if(l!=null)a=B.a.c9(a,m,s,l)}return new A.pN(a,j,c)},
yK(a,b,c,d,e){var s,r,q
for(s=b;s<c;++s){r=a.charCodeAt(s)^96
if(r>95)r=31
q='\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe3\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x0e\x03\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xea\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\n\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\xeb\xeb\x8b\xeb\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\x83\xeb\xeb\x8b\xeb\x8b\xeb\xcd\x8b\xeb\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x92\x83\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\x8b\xeb\x8b\xeb\x8b\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xebD\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x12D\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\xe5\xe5\xe5\x05\xe5D\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe8\x8a\xe5\xe5\x05\xe5\x05\xe5\xcd\x05\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x8a\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05f\x05\xe5\x05\xe5\xac\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05\xe5\xe5\xe5\x05\xe5D\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\xe5\x8a\xe5\xe5\x05\xe5\x05\xe5\xcd\x05\xe5\x05\x05\x05\x05\x05\x05\x05\x05\x05\x8a\x05\x05\x05\x05\x05\x05\x05\x05\x05\x05f\x05\xe5\x05\xe5\xac\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7D\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\xe7\xe7\xe7\xe7\xe7\xcd\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\x07\x07\x07\x07\x07\x07\x07\x07\x07\xe7\xe7\xe7\xe7\xe7\xac\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7D\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\xe7\xe7\xe7\xe7\xe7\xe7\xcd\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\xe7\x8a\x07\x07\x07\x07\x07\x07\x07\x07\x07\x07\xe7\xe7\xe7\xe7\xe7\xac\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\x05\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x10\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x12\n\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\n\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xec\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\xec\xec\xec\f\xec\xec\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\f\xec\xec\xec\xec\f\xec\f\xec\xcd\f\xec\f\f\f\f\f\f\f\f\f\xec\f\f\f\f\f\f\f\f\f\f\xec\f\xec\f\xec\f\xed\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\xed\xed\xed\r\xed\xed\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\r\xed\xed\xed\xed\r\xed\r\xed\xed\r\xed\r\r\r\r\r\r\r\r\r\xed\r\r\r\r\r\r\r\r\r\r\xed\r\xed\r\xed\r\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xea\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x0f\xea\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe1\xe1\x01\xe1\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\xe1\xe9\xe1\xe1\x01\xe1\x01\xe1\xcd\x01\xe1\x01\x01\x01\x01\x01\x01\x01\x01\x01\t\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01"\x01\xe1\x01\xe1\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x11\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xe9\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\t\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\x13\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xeb\xeb\v\xeb\xeb\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\v\xeb\xea\xeb\xeb\v\xeb\v\xeb\xcd\v\xeb\v\v\v\v\v\v\v\v\v\xea\v\v\v\v\v\v\v\v\v\v\xeb\v\xeb\v\xeb\xac\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\xf5\x15\xf5\x15\x15\xf5\x15\x15\x15\x15\x15\x15\x15\x15\x15\x15\xf5\xf5\xf5\xf5\xf5\xf5'.charCodeAt(d*96+r)
d=q&31
e[q>>>5]=s}return d},
y_(a){if(a.b===7&&B.a.K(a.a,"package")&&a.c<=0)return A.yM(a.a,a.e,a.f)
return-1},
yM(a,b,c){var s,r,q
for(s=b,r=0;s<c;++s){q=a.charCodeAt(s)
if(q===47)return r!==0?s:-1
if(q===37||q===58)return-1
r|=q^46}return-1},
yp(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=0,q=0;q<s;++q){p=b.charCodeAt(c+q)
o=a.charCodeAt(q)^p
if(o!==0){if(o===32){n=p|o
if(97<=n&&n<=122){r=32
continue}}return-1}}return r},
aA:function aA(a,b,c){this.a=a
this.b=b
this.c=c},
qS:function qS(){},
qT:function qT(){},
jW:function jW(a,b){this.a=a
this.$ti=b},
bT:function bT(a,b,c){this.a=a
this.b=b
this.c=c},
b1:function b1(a){this.a=a},
rr:function rr(){},
W:function W(){},
hW:function hW(a){this.a=a},
c4:function c4(){},
a3:function a3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
e1:function e1(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fj:function fj(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
fR:function fR(a){this.a=a},
jp:function jp(a){this.a=a},
aX:function aX(a){this.a=a},
ib:function ib(a){this.a=a},
iV:function iV(){},
fG:function fG(){},
jV:function jV(a){this.a=a},
aU:function aU(a,b,c){this.a=a
this.b=b
this.c=c},
iw:function iw(){},
n:function n(){},
M:function M(a,b,c){this.a=a
this.b=b
this.$ti=c},
F:function F(){},
k:function k(){},
ku:function ku(){},
a0:function a0(a){this.a=a},
pO:function pO(a){this.a=a},
hD:function hD(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.y=_.x=_.w=$},
pN:function pN(a,b,c){this.a=a
this.b=b
this.c=c},
bk:function bk(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=null},
jS:function jS(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.y=_.x=_.w=$},
io:function io(a){this.a=a},
yr(a,b,c,d){if(a)return""+d+"-"+c+"-begin"
if(b)return""+d+"-"+c+"-end"
return c},
yC(a){var s=$.eI.i(0,a)
if(s==null)return a
return a+"-"+A.q(s)},
D0(a){var s,r
if(!$.eI.E(a))return
s=$.eI.i(0,a)
s.toString
r=s-1
s=$.eI
if(r<=0)s.H(0,a)
else s.l(0,a,r)},
G_(a,b,c,d,e){var s,r,q,p,o,n
if(c===9||c===11||c===10)return
if($.eL>1e4&&$.eI.a===0){$.kY().clearMarks()
$.kY().clearMeasures()
$.eL=0}s=c===1||c===5
r=c===2||c===7
q=A.yr(s,r,d,a)
if(s){p=$.eI.i(0,q)
if(p==null)p=0
$.eI.l(0,q,p+1)
q=A.yC(q)}o=$.kY()
o.toString
o.mark(q,$.zI().parse(e))
$.eL=$.eL+1
if(r){n=A.yr(!0,!1,d,a)
o=$.kY()
o.toString
o.measure(d,A.yC(n),q)
$.eL=$.eL+1
A.D0(n)}B.b.n7($.eL,0,10001)},
FN(a){if(a==null||a.a===0)return"{}"
return B.h.b8(a)},
uf:function uf(){},
ud:function ud(){},
vN:function vN(a,b){this.a=a
this.b=b},
yZ(){return v.G},
AV(a){return a},
AN(a){return a},
AP(a){return a},
vF(a){return a},
wV(a){return new v.G.Promise(A.aZ(new A.n3(a)))},
iT:function iT(a){this.a=a},
n3:function n3(a){this.a=a},
n1:function n1(a){this.a=a},
n2:function n2(a){this.a=a},
uc(a){var s
if(typeof a=="function")throw A.a(A.J("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(){return b(c)}}(A.CS,a)
s[$.dD()]=a
return s},
bB(a){var s
if(typeof a=="function")throw A.a(A.J("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.CT,a)
s[$.dD()]=a
return s},
aZ(a){var s
if(typeof a=="function")throw A.a(A.J("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e){return b(c,d,e,arguments.length)}}(A.CU,a)
s[$.dD()]=a
return s},
kM(a){var s
if(typeof a=="function")throw A.a(A.J("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f){return b(c,d,e,f,arguments.length)}}(A.CV,a)
s[$.dD()]=a
return s},
eK(a){var s
if(typeof a=="function")throw A.a(A.J("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f,g){return b(c,d,e,f,g,arguments.length)}}(A.CW,a)
s[$.dD()]=a
return s},
wa(a){var s
if(typeof a=="function")throw A.a(A.J("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e,f,g,h){return b(c,d,e,f,g,h,arguments.length)}}(A.CX,a)
s[$.dD()]=a
return s},
CS(a){return a.$0()},
CT(a,b,c){if(c>=1)return a.$1(b)
return a.$0()},
CU(a,b,c,d){if(d>=2)return a.$2(b,c)
if(d===1)return a.$1(b)
return a.$0()},
CV(a,b,c,d,e){if(e>=3)return a.$3(b,c,d)
if(e===2)return a.$2(b,c)
if(e===1)return a.$1(b)
return a.$0()},
CW(a,b,c,d,e,f){if(f>=4)return a.$4(b,c,d,e)
if(f===3)return a.$3(b,c,d)
if(f===2)return a.$2(b,c)
if(f===1)return a.$1(b)
return a.$0()},
CX(a,b,c,d,e,f,g){if(g>=5)return a.$5(b,c,d,e,f)
if(g===4)return a.$4(b,c,d,e)
if(g===3)return a.$3(b,c,d)
if(g===2)return a.$2(b,c)
if(g===1)return a.$1(b)
return a.$0()},
yz(a){return a==null||A.kN(a)||typeof a=="number"||typeof a=="string"||t.jx.b(a)||t.p.b(a)||t.nn.b(a)||t.m6.b(a)||t.i7.b(a)||t.bW.b(a)||t.mC.b(a)||t.pk.b(a)||t.kI.b(a)||t.lo.b(a)||t.fW.b(a)},
EI(a){if(A.yz(a))return a
return new A.uR(new A.dr(t.mp)).$1(a)},
uK(a,b){return a[b]},
yT(a,b,c){return a[b].apply(a,c)},
Ec(a,b){var s,r
if(b==null)return new a()
if(b instanceof Array)switch(b.length){case 0:return new a()
case 1:return new a(b[0])
case 2:return new a(b[0],b[1])
case 3:return new a(b[0],b[1],b[2])
case 4:return new a(b[0],b[1],b[2],b[3])}s=[null]
B.c.aa(s,b)
r=a.bind.apply(a,s)
String(r)
return new r()},
ar(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.aa(s,b.h("aa<0>"))
a.then(A.cI(new A.v7(r),1),A.cI(new A.v8(r),1))
return s},
uR:function uR(a){this.a=a},
v7:function v7(a){this.a=a},
v8:function v8(a){this.a=a},
z2(a,b){return Math.max(a,b)},
B9(){return B.b4},
rY:function rY(){},
rZ:function rZ(a){this.a=a},
ij:function ij(a,b){this.a=a
this.b=b},
fV:function fV(a){this.a=a},
fI:function fI(a,b,c){var _=this
_.a=$
_.b=!1
_.c=a
_.e=b
_.$ti=c},
oM:function oM(){},
oN:function oN(a,b){this.a=a
this.b=b},
oL:function oL(){},
oK:function oK(a){this.a=a},
oJ:function oJ(a,b){this.a=a
this.b=b},
eB:function eB(a){this.a=a},
U:function U(){},
lz:function lz(a){this.a=a},
lA:function lA(a){this.a=a},
lB:function lB(a,b){this.a=a
this.b=b},
lC:function lC(a){this.a=a},
lD:function lD(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
f8:function f8(){},
eE:function eE(){},
d9:function d9(a){this.$ti=a},
ew:function ew(a,b,c){this.a=a
this.b=b
this.c=c},
iK:function iK(a){this.$ti=a},
xa(){throw A.a(A.P(u.O))},
Bx(){throw A.a(A.P("Cannot modify an unmodifiable Map"))},
iR:function iR(){},
js:function js(){},
Fl(a){return new A.ct("Request aborted by `abortTrigger`",a)},
l4:function l4(){},
ct:function ct(a,b){this.a=a
this.b=b},
i_:function i_(){},
i0:function i0(){},
lh:function lh(){},
li:function li(){},
lj:function lj(){},
yO(a,b){var s
if(t.m.b(a)&&"AbortError"===a.name)return new A.ct("Request aborted by `abortTrigger`",b.b)
if(!(a instanceof A.bR)){s=J.be(a)
if(B.a.K(s,"TypeError: "))s=B.a.a0(s,11)
a=new A.bR(s,b.b)}return a},
yE(a,b,c){A.il(A.yO(a,c),b)},
CR(a,b){return new A.bz(!1,new A.u3(a,b),t.fb)},
eN(a,b,c){return A.DA(a,b,c)},
DA(a,a0,a1){var s=0,r=A.i(t.H),q,p=2,o=[],n,m,l,k,j,i,h,g,f,e,d,c,b
var $async$eN=A.d(function(a2,a3){if(a2===1){o.push(a3)
s=p}for(;;)switch(s){case 0:e={}
d=a0.body
c=d==null?null:d.getReader()
s=c==null?3:4
break
case 3:s=5
return A.b(a1.n(),$async$eN)
case 5:s=1
break
case 4:e.a=null
e.b=e.c=!1
a1.f=new A.ug(e)
a1.r=new A.uh(e,c,a)
d=t.Z,k=t.m,j=t.D,i=t.h
case 6:n=null
p=9
s=12
return A.b(A.ar(c.read(),k),$async$eN)
case 12:n=a3
p=2
s=11
break
case 9:p=8
b=o.pop()
m=A.E(b)
l=A.I(b)
s=!e.c?13:14
break
case 13:e.b=!0
d=A.yO(m,a)
k=l
j=a1.b
if(j>=4)A.r(a1.ap())
if((j&1)!==0){j=a1.ga6()
j.a9(d,k==null?B.t:k)}s=15
return A.b(a1.n(),$async$eN)
case 15:case 14:s=7
break
s=11
break
case 8:s=2
break
case 11:if(n.done){a1.j8()
s=7
break}else{g=n.value
g.toString
d.a(g)
f=a1.b
if(f>=4)A.r(a1.ap())
if((f&1)!==0)a1.ga6().N(g)}g=a1.b
s=((g&1)!==0?(a1.ga6().e&4)!==0:(g&2)===0)?16:17
break
case 16:g=e.a
s=18
return A.b((g==null?e.a=new A.aa(new A.l($.m,j),i):g).a,$async$eN)
case 18:case 17:if((a1.b&1)===0){s=7
break}s=6
break
case 7:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$eN,r)},
i4:function i4(a){this.b=!1
this.c=a},
ln:function ln(a){this.a=a},
lo:function lo(a){this.a=a},
u3:function u3(a,b){this.a=a
this.b=b},
ug:function ug(a){this.a=a},
uh:function uh(a,b,c){this.a=a
this.b=b
this.c=c},
cP:function cP(a){this.a=a},
ly:function ly(a){this.a=a},
wL(a,b){return new A.bR(a,b)},
bR:function bR(a,b){this.a=a
this.b=b},
vi(a,b,c){var s=new Uint8Array(0),r=$.zj()
if(!r.b.test(a))A.r(A.b_(a,"method","Not a valid method"))
r=t.N
return new A.hR(c,s,a,b,A.vx(new A.lh(),new A.li(),r,r))},
os:function os(){},
hR:function hR(a,b,c,d,e){var _=this
_.cx=a
_.y=b
_.a=c
_.b=d
_.r=e
_.w=!1},
jE:function jE(){},
j5(a){var s=0,r=A.i(t.b),q,p,o,n,m,l,k,j
var $async$j5=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(a.w.hh(),$async$j5)
case 3:p=c
o=a.b
n=a.a
m=a.e
l=a.c
k=A.zf(p)
j=p.length
k=new A.e3(k,n,o,l,j,m,!1,!0)
k.eS(o,j,m,!1,!0,l,n)
q=k
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$j5,r)},
w6(a){var s=a.i(0,"content-type")
if(s!=null)return A.x7(s)
return A.nV("application","octet-stream",null)},
e3:function e3(a,b,c,d,e,f,g,h){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h},
Bq(a,b,c,d,e,f,g,h){var s=new A.cw(A.ze(a),h,b,g,c,d,!1,!0)
s.eS(b,c,d,!1,!0,g,h)
return s},
cw:function cw(a,b,c,d,e,f,g,h){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h},
jl:function jl(a,b,c,d,e,f,g,h){var _=this
_.w=a
_.a=b
_.b=c
_.c=d
_.d=e
_.e=f
_.f=g
_.r=h},
A8(a){return a.toLowerCase()},
eZ:function eZ(a,b,c){this.a=a
this.c=b
this.$ti=c},
x7(a){return A.F4("media type",a,new A.nW(a))},
nV(a,b,c){var s=t.N
if(c==null)s=A.T(s,s)
else{s=new A.eZ(A.Ed(),A.T(s,t.gc),t.kj)
s.aa(0,c)}return new A.ft(a.toLowerCase(),b.toLowerCase(),new A.df(s,t.ph))},
ft:function ft(a,b,c){this.a=a
this.b=b
this.c=c},
nW:function nW(a){this.a=a},
nY:function nY(a){this.a=a},
nX:function nX(){},
Eq(a){var s
a.jj($.zL(),"quoted string")
s=a.gh4().i(0,0)
return A.zb(B.a.t(s,1,s.length-1),$.zK(),new A.uF(),null)},
uF:function uF(){},
co:function co(a,b){this.a=a
this.b=b},
dU:function dU(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.d=c
_.e=d
_.r=e
_.w=f},
vz(a){return $.AX.cD(a,new A.nQ(a))},
x5(a,b,c){var s=new A.dV(a,b,c)
if(b==null)s.c=B.m
else b.d.l(0,a,s)
return s},
dV:function dV(a,b,c){var _=this
_.a=a
_.b=b
_.c=null
_.d=c
_.f=null},
nQ:function nQ(a){this.a=a},
yB(a){return a},
yP(a,b){var s,r,q,p,o,n,m,l
for(s=b.length,r=1;r<s;++r){if(b[r]==null||b[r-1]!=null)continue
for(;s>=1;s=q){q=s-1
if(b[q]!=null)break}p=new A.a0("")
o=a+"("
p.a=o
n=A.a5(b)
m=n.h("db<1>")
l=new A.db(b,0,s,m)
l.l1(b,0,s,n.c)
m=o+new A.a8(l,new A.ux(),m.h("a8<X.E,j>")).bp(0,", ")
p.a=m
p.a=m+("): part "+(r-1)+" was null, but part "+r+" was not.")
throw A.a(A.J(p.j(0),null))}},
m0:function m0(a){this.a=a},
m1:function m1(){},
m2:function m2(){},
ux:function ux(){},
nG:function nG(){},
iW(a,b){var s,r,q,p,o,n=b.kw(a)
b.bI(a)
if(n!=null)a=B.a.a0(a,n.length)
s=t.s
r=A.u([],s)
q=A.u([],s)
s=a.length
if(s!==0&&b.bo(a.charCodeAt(0))){q.push(a[0])
p=1}else{q.push("")
p=0}for(o=p;o<s;++o)if(b.bo(a.charCodeAt(o))){r.push(B.a.t(a,p,o))
q.push(a[o])
p=o+1}if(p<s){r.push(B.a.a0(a,p))
q.push("")}return new A.o2(b,n,r,q)},
o2:function o2(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
xb(a){return new A.iX(a)},
iX:function iX(a){this.a=a},
Bs(){var s,r,q,p,o,n,m,l,k=null
if(A.vJ().gaD()!=="file")return $.hN()
if(!B.a.bF(A.vJ().gaR(),"/"))return $.hN()
s=A.ye(k,0,0)
r=A.yb(k,0,0,!1)
q=A.yd(k,0,0,k)
p=A.ya(k,0,0)
o=A.tJ(k,"")
if(r==null)if(s.length===0)n=o!=null
else n=!0
else n=!1
if(n)r=""
n=r==null
m=!n
l=A.yc("a/b",0,3,k,"",m)
if(n&&!B.a.K(l,"/"))l=A.w1(l,m)
else l=A.dw(l)
if(A.hE("",s,n&&B.a.K(l,"//")?"":r,o,l,q,p).hi()==="a\\b")return $.kW()
return $.zn()},
pd:function pd(){},
o3:function o3(a,b,c){this.d=a
this.e=b
this.f=c},
pP:function pP(a,b,c,d){var _=this
_.d=a
_.e=b
_.f=c
_.r=d},
qi:function qi(a,b,c,d){var _=this
_.d=a
_.e=b
_.f=c
_.r=d},
A4(){var s=$.m,r=t.D,q=t.h,p=new A.aa(new A.l(s,r),q),o=A.bs(t.A)
o.q(0,p)
return new A.hQ(p,o,new A.aa(new A.l(s,r),q))},
hQ:function hQ(a,b,c){this.a=a
this.b=b
this.c=c},
l2:function l2(a,b,c){this.a=a
this.b=b
this.c=c},
l3:function l3(a,b){this.a=a
this.b=b},
cr:function cr(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
BB(a){switch(a){case"PUT":return B.bX
case"PATCH":return B.bW
case"DELETE":return B.bV
default:return null}},
f6:function f6(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
fT:function fT(a,b,c){this.c=a
this.a=b
this.b=c},
EQ(a){var s=a.$ti.h("aM<D.T,bf>"),r=s.h("ce<D.T>")
return new A.cS(new A.ce(new A.v4(),new A.aM(new A.v5(),a,s),r),r.h("cS<D.T,K>"))},
v5:function v5(){},
v4:function v4(){},
vl(a){return new A.f5(a)},
pf(a){return A.Bu(a)},
Bu(a){var s=0,r=A.i(t.jM),q,p=2,o=[],n,m,l,k
var $async$pf=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:p=4
s=7
return A.b(B.l.ng(a.w),$async$pf)
case 7:n=c
m=A.xt(a,n)
q=m
s=1
break
p=2
s=6
break
case 4:p=3
k=o.pop()
if(t.L.b(A.E(k))){q=A.xu(a)
s=1
break}else throw k
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$pf,r)},
xv(a){var s,r,q
try{s=A.wj(A.w6(a.e)).aI(a.w)
r=A.xt(a,s)
return r}catch(q){if(t.L.b(A.E(q)))return A.xu(a)
else throw q}},
xt(a,b){var s,r,q=J.eV(B.h.c5(b,null),"error")
A:{if(t.f.b(q)){s=A.Bt(q)
break A}s=null
break A}r=s==null?b:s
s=a.c
if(s==null)s="Request failed"
return new A.dc(a.b,s+": "+r)},
xu(a){var s=a.c
if(s==null)s="Request failed"
return new A.dc(a.b,s)},
Bt(a){var s,r=a.i(0,"code"),q=a.i(0,"description"),p=a.i(0,"name"),o=a.i(0,"details")
if(typeof r!="string"||typeof q!="string")return null
s=(typeof p=="string"?r+("("+p+")"):r)+": "+q
if(typeof o=="string")s=s+", "+o
return s.charCodeAt(0)==0?s:s},
f5:function f5(a){this.a=a},
e_:function e_(a){this.a=a},
dc:function dc(a,b){this.a=a
this.b=b},
Ds(){var s=A.x5("PowerSync",null,A.T(t.N,t.W))
if(s.b!=null)A.r(A.P('Please set "hierarchicalLoggingEnabled" to true if you want to change the level on a non-root logger.'))
J.A(s.c,B.p)
s.c=B.p
s.fc().O(new A.ue())
return s},
ue:function ue(){},
cZ:function cZ(a){this.a=a},
w9(a){var s,r,q,p=A.bs(t.N)
for(s=a.gA(a);s.m();){r=s.gp()
q=A.Es(r)
if(q!=null)p.q(0,q)
else if(!B.a.K(r,"ps_"))p.q(0,r)}return p},
bf:function bf(a){this.a=a},
i5(a,b){var s=0,r=A.i(t.G),q
var $async$i5=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(a.aC(b,B.n),$async$i5)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$i5,r)},
lr(a){var s=0,r=A.i(t.N),q,p
var $async$lr=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.i5(a,"SELECT powersync_client_id() as client_id"),$async$lr)
case 3:p=c
q=A.al(p.gai(p).i(0,"client_id"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$lr,r)},
vj(a,b,c,d){return a.mW(new A.lw(b,d),c,d)},
eY(a,b){var s=0,r=A.i(t.y),q,p,o,n,m
var $async$eY=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(a.oQ(new A.lu(),t.I),$async$eY)
case 3:p=d
if(p==null){q=!1
s=1
break}o=a
n=A
m=p
s=5
return A.b(b.$0(),$async$eY)
case 5:s=4
return A.b(o.b0(new n.lv(m,d),t.y),$async$eY)
case 4:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$eY,r)},
lt(a){var s=0,r=A.i(t.d_),q,p,o,n,m,l,k,j,i,h,g
var $async$lt=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(a.dH("SELECT * FROM ps_crud ORDER BY id ASC LIMIT 1"),$async$lt)
case 3:g=c
if(g==null)p=null
else{o=B.h.c5(A.al(g.i(0,"data")),null)
p=A.R(g.i(0,"id"))
n=J.ab(o)
m=A.BB(A.al(n.i(o,"op")))
m.toString
l=A.al(n.i(o,"type"))
k=A.al(n.i(o,"id"))
j=A.R(g.i(0,"tx_id"))
i=t.h9
h=i.a(n.i(o,"data"))
i=i.a(n.i(o,"old"))
i=new A.f6(p,j,m,l,k,A.kJ(n.i(o,"metadata")),h,i)
p=i}q=p
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$lt,r)},
ls(a){var s=0,r=A.i(t.y),q,p
var $async$ls=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.i5(a,"SELECT 1 FROM ps_crud LIMIT 1"),$async$ls)
case 3:p=c
q=!p.gF(p)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ls,r)},
lp(a,b,c){var s=0,r=A.i(t.N),q
var $async$lp=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=3
return A.b(a.b0(new A.lq(b,c),t.N),$async$lp)
case 3:q=e
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$lp,r)},
iZ(a,b,c){var s=0,r=A.i(t.T),q,p
var $async$iZ=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:p=A
s=3
return A.b(a.bx("SELECT CAST(powersync_control(?, ?) AS TEXT)",[b,c]),$async$iZ)
case 3:q=p.kJ(e.b[0])
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$iZ,r)},
d4(a,b,c){var s=0,r=A.i(t.T),q
var $async$d4=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=3
return A.b(A.iZ(a,b+"_checkpoint_request_id",c),$async$d4)
case 3:q=e
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$d4,r)},
o5(a){var s=0,r=A.i(t.N),q,p
var $async$o5=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.d4(a,"next",null),$async$o5)
case 3:p=c
p.toString
q=p
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$o5,r)},
lw:function lw(a,b){this.a=a
this.b=b},
lu:function lu(){},
lv:function lv(a,b){this.a=a
this.b=b},
lq:function lq(a,b){this.a=a
this.b=b},
dH:function dH(a){this.a=a},
lI:function lI(a,b,c){this.a=a
this.b=b
this.c=c},
lJ:function lJ(a,b){this.a=a
this.b=b},
ca:function ca(){},
hm:function hm(){},
ei:function ei(a){this.a=a},
h8:function h8(){},
AH(a){return A.AG(a)},
AG(a){var s,r,q,p,o,n,m,l,k,j="UpdateSyncStatus",i="EstablishSyncStream",h="FetchCredentials",g="CloseSyncStream",f="DidCompleteSync",e="CheckpointDelayedDueToLocalData",d="HandleDiagnostics"
A:{s=a.i(0,"LogLine")
if(s==null)r=a.E("LogLine")
else r=!0
if(r){t.f.a(s)
r=new A.fr(A.al(s.i(0,"severity")),A.al(s.i(0,"line")))
break A}q=a.i(0,j)
if(q==null)r=a.E(j)
else r=!0
if(r){r=t.f
r=new A.fS(A.An(r.a(r.a(q).i(0,"status"))))
break A}p=a.i(0,i)
if(p==null)r=a.E(i)
else r=!0
if(r){r=A.Aw(t.f.a(p))
break A}o=a.i(0,h)
if(o==null)r=a.E(h)
else r=!0
if(r){r=new A.fd(A.aY(t.f.a(o).i(0,"did_expire")))
break A}n=a.i(0,g)
if(n==null)r=a.E(g)
else r=!0
if(r){t.f.a(n)
r=new A.dI(A.aY(n.i(0,"hide_disconnect")))
break A}m=a.i(0,f)
if(m==null)r=a.E(f)
else r=!0
if(r){r=B.aQ
break A}l=a.i(0,e)
if(l==null)r=a.E(e)
else r=!0
if(r){r=B.aP
break A}k=a.i(0,d)
if(k==null)r=a.E(d)
else r=!0
if(r){r=new A.fh(t.f.a(k))
break A}r=new A.fQ(a)
break A}return r},
Aw(a){var s=t.f,r=s.a(a.i(0,"request")),q=a.i(0,"checkpoint_request")
A:{if(q==null){s=null
break A}s.a(q)
s=new A.lH(A.al(q.i(0,"client_id")),A.al(q.i(0,"checkpoint_request_id")))
break A}return new A.dN(r,s)},
An(a){var s,r,q,p,o,n=A.aY(a.i(0,"connected"))
A.aY(a.i(0,"connecting"))
s=A.u([],t.cH)
for(r=J.Z(t.j.a(a.i(0,"priority_status"))),q=t.f;r.m();)s.push(A.Ao(q.a(r.gp())))
p=a.i(0,"downloading")
A:{if(p==null)break A
A.Ar(q.a(p))
break A}s=J.dE(t.ia.a(a.i(0,"streams")),new A.m5(),t.em)
A.ap(s,s.$ti.h("X.E"))
o=A.kJ(a.i(0,"internal_last_applied_checkpoint_request_id"))
B:{if(o==null){s=null
break B}s=new A.cZ(v.G.BigInt(o))
break B}return new A.m4(a,n,s)},
Ao(a){var s,r=A.R(a.i(0,"priority")),q=A.w3(a.i(0,"has_synced")),p=a.i(0,"last_synced_at")
A:{if(p==null){s=null
break A}s=A.mP(A.R(p))
break A}return new A.kh(q,s,r)},
Ar(a){return new A.mQ(t.f.a(a.i(0,"buckets")).cB(0,new A.mR(),t.N,t.cV))},
fr:function fr(a,b){this.a=a
this.b=b},
dN:function dN(a,b){this.a=a
this.b=b},
lH:function lH(a,b){this.a=a
this.b=b},
fS:function fS(a){this.a=a},
m4:function m4(a,b,c){this.a=a
this.b=b
this.r=c},
m5:function m5(){},
mQ:function mQ(a){this.a=a},
mR:function mR(){},
fd:function fd(a){this.a=a},
dI:function dI(a){this.a=a},
f9:function f9(){},
f0:function f0(){},
fh:function fh(a){this.a=a},
fQ:function fQ(a){this.a=a},
nF:function nF(a,b){this.a=a
this.b=b},
Bd(a){var s=a.a
return s==null?B.L:s},
Be(a){var s=a.b
return s==null?B.K:s},
fM:function fM(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
lG:function lG(){},
fp:function fp(){},
d7:function d7(a){this.a=a},
pe:function pe(a,b){this.a=a
this.b=b},
xw(a,b){if(B.w.D(0,b))return null
else return b==null?a:b},
aL:function aL(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pm:function pm(){},
Am(a){var s,r,q,p,o,n,m,l,k,j,i=A.al(a.i(0,"name")),h=t.h9.a(a.i(0,"parameters")),g=A.w4(a.i(0,"priority"))
A:{if(g!=null){s=g
break A}s=2147483647
break A}r=t.f.a(a.i(0,"progress"))
q=A.R(r.i(0,"total"))
r=A.R(r.i(0,"downloaded"))
p=A.aY(a.i(0,"active"))
o=A.aY(a.i(0,"is_default"))
n=A.aY(a.i(0,"has_explicit_subscription"))
m=a.i(0,"expires_at")
B:{if(m==null){l=null
break B}l=A.mP(A.R(m))
break B}k=a.i(0,"last_synced_at")
C:{if(k==null){j=null
break C}j=A.mP(A.R(k))
break C}return new A.dL(i,h,s,new A.kc(r,q),p,o,n,l,j)},
dL:function dL(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
z3(a,b){var s=null,r={},q=A.bI(s,s,s,s,!0,b)
r.a=null
r.b=!1
q.d=new A.uZ(r,a,q,b)
q.r=new A.v_(r)
q.e=new A.v0(r)
q.f=new A.v1(r)
return new A.a4(q,A.p(q).h("a4<1>"))},
EP(a){var s,r
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)a[r].aj()},
ET(a){var s,r
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a6)(a),++r)a[r].am()},
kP(a){var s=0,r=A.i(t.H)
var $async$kP=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=2
return A.b(A.n7(new A.a8(a,new A.uA(),A.a5(a).h("a8<1,o<~>>")),t.H),$async$kP)
case 2:return A.f(null,r)}})
return A.h($async$kP,r)},
EW(a,b){var s=null,r={},q=A.bI(s,s,s,s,!0,b)
r.a=!1
q.r=new A.vd(r,a.bb(new A.ve(q,b),new A.vf(r,q),t.P))
return new A.a4(q,A.p(q).h("a4<1>"))},
BG(a,b,c,d,e,f){var s=new A.l($.m,t.D),r=new A.aa(s,t.h),q=a.O(null),p=new A.pQ(e,r,q,f)
q.bt(p)
p.$1(c)
b.J(new A.pR(r,d,q))
return s},
C_(a){return new A.eh(a,new DataView(new ArrayBuffer(4)))},
uZ:function uZ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
uY:function uY(a,b,c){this.a=a
this.b=b
this.c=c},
uW:function uW(a,b){this.a=a
this.b=b},
uX:function uX(a,b){this.a=a
this.b=b},
v_:function v_(a){this.a=a},
v0:function v0(a){this.a=a},
v1:function v1(a){this.a=a},
uA:function uA(){},
ve:function ve(a,b){this.a=a
this.b=b},
vf:function vf(a,b){this.a=a
this.b=b},
vd:function vd(a,b){this.a=a
this.b=b},
pQ:function pQ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pR:function pR(a,b,c){this.a=a
this.b=b
this.c=c},
eh:function eh(a,b){var _=this
_.a=a
_.b=b
_.c=4
_.d=null},
w7(a){var s,r={},q=new A.l($.m,t.D)
r.a=null
s=new A.u9(r,new A.N(q,t.F))
r.a=A.pA(a,s)
return new A.Q(q,s)},
DQ(a){var s="Sync service error"
if(a instanceof A.bR)return s
else if(a instanceof A.dc)if(a.a===401)return"Authorization error"
else return s
else if(a instanceof A.a3||t.lW.b(a))return"Configuration error"
else if(a instanceof A.f5)return"Credentials error"
else if(a instanceof A.e_)return"Protocol error"
else return J.wz(a).j(0)+": "+A.q(a)},
Bb(a){return new A.cs(a)},
eJ(a,b){if((a.a.a.a&30)===0)return!1
return b instanceof A.bR||b instanceof A.bC},
oY:function oY(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=null
_.Q=k
_.as=l
_.at=null
_.ax=m
_.ay=n
_.ch=o
_.CW=p
_.cx=null},
pb:function pb(a,b){this.a=a
this.b=b},
p0:function p0(a,b,c){this.a=a
this.b=b
this.c=c},
p1:function p1(a){this.a=a},
oZ:function oZ(a,b,c){this.a=a
this.b=b
this.c=c},
pa:function pa(a,b,c){this.a=a
this.b=b
this.c=c},
p9:function p9(a,b){this.a=a
this.b=b},
p8:function p8(){},
p2:function p2(a){this.a=a},
p3:function p3(a,b,c){this.a=a
this.b=b
this.c=c},
p4:function p4(a){this.a=a},
p7:function p7(a,b,c){this.a=a
this.b=b
this.c=c},
p5:function p5(a,b){this.a=a
this.b=b},
p6:function p6(){},
p_:function p_(a,b){this.a=a
this.b=b},
u9:function u9(a,b){this.a=a
this.b=b},
qt:function qt(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
qu:function qu(){},
qA:function qA(a){this.a=a},
qz:function qz(a){this.a=a},
qy:function qy(){},
qv:function qv(a,b){this.a=a
this.b=b},
qw:function qw(a){this.a=a},
qx:function qx(a){this.a=a},
dK:function dK(a,b){this.a=a
this.b=b},
cs:function cs(a){this.a=a},
fU:function fU(){},
fP:function fP(){},
fg:function fg(a){this.a=a},
f1:function f1(a,b){this.a=a
this.b=b},
Cr(a,b){var s=null,r=new A.kj(a,b,A.bI(s,s,s,s,!0,t.p))
r.l9(a,b)
return r},
e2:function e2(a){this.a=a
this.b=0},
or:function or(a,b){this.a=a
this.b=b},
kj:function kj(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
td:function td(a){this.a=a},
Fk(a){var s
if(t.p.b(a)){s=B.f.gar(a)
if(a.byteOffset===0&&J.zZ(s)===a.length)return t.a.a(s)}return t.a.a(B.f.gar(new Uint8Array(A.w8(a))))},
vB:function vB(a){this.a=a},
vV:function vV(a){this.a=!1
this.b=a
this.c=null},
Aj(a,b){var s=new A.ci(b)
s.kY(a,b)
return s},
Bv(a){var s=null,r=new A.fI(B.aH,A.T(t.ir,t.mQ),t.a9),q=t.pp
r.a=A.bI(r.gmF(),r.gm7(),r.gmG(),r.gmI(),!0,q)
q=new A.e9(a,new A.fM(s,s,s,s,B.ap,s,s,s,!0),r,A.bI(s,s,s,s,!1,q),{},A.T(t.hM,t.eL),A.u([],t.bN))
q.l2(a)
return q},
pn:function pn(a){this.a=a},
po:function po(a){this.a=a},
ci:function ci(a){var _=this
_.a=$
_.b=a
_.f=_.e=_.d=_.c=null},
lY:function lY(a){this.a=a},
lX:function lX(a){this.a=a},
lZ:function lZ(a){this.a=a},
e9:function e9(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c="{}"
_.d=c
_.e=d
_.f=null
_.r=e
_.w=null
_.x=f
_.y=g},
pl:function pl(a){this.a=a},
pg:function pg(a,b,c){this.a=a
this.b=b
this.c=c},
ph:function ph(a,b,c){this.a=a
this.b=b
this.c=c},
pi:function pi(a){this.a=a},
pj:function pj(a){this.a=a},
pk:function pk(a){this.a=a},
fZ:function fZ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
hs:function hs(a){this.a=a},
h7:function h7(a){this.a=a},
h4:function h4(a,b){this.a=a
this.b=b},
xC(a){var s=a.content
s=B.c.b9(s,new A.pM(),t.E)
s=A.ap(s,s.$ti.h("X.E"))
return s},
xo(a){var s,r,q=a.endpoint,p=a.token,o=a.userId
if(o==null)o=null
if(a.expiresAt==null)s=null
else{s=a.expiresAt
s.toString
s=A.mP(A.R(s))}r=A.dg(q)
if(!r.el("http")&&!r.el("https")||r.gbH().length===0)A.r(A.b_(q,"PowerSync endpoint must be a valid URL",null))
return new A.cr(q,p,o,s)},
xp(a){var s,r
A:{if(a==null){s=null
break A}if(B.w.D(0,a)){s=-1
break A}r=J.be(a)
s=r
break A}return s},
BI(a,b){var s=null,r=t.S,q=$.m,p=A.bI(s,s,s,s,!1,t.l4),o=$.wv()
r=new A.jC(A.T(r,t.kn),A.T(r,t.A),new A.aa(new A.l(q,t.D),t.h),a,b,p,o,s)
r.l4(s,s,s,a,b)
return r},
af:function af(a,b){this.a=a
this.b=b},
pM:function pM(){},
jC:function jC(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=0
_.f=_.e=!1
_.w=_.r=null
_.y=d
_.z=e
_.Q=f
_.as=g
_.at=h},
qo:function qo(a){this.a=a},
qj:function qj(){},
qk:function qk(a,b){this.a=a
this.b=b},
ql:function ql(a,b){this.a=a
this.b=b},
qm:function qm(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
qn:function qn(a,b){this.a=a
this.b=b},
oh:function oh(a){this.a=a},
j4:function j4(a){this.a=a},
i8:function i8(){},
EK(){var s=null,r=v.G,q=r.location.href,p=t.m,o=A.bI(s,s,s,s,!0,p),n=t.cj
new A.qp(new A.rs(new A.o6(new A.rp(q)),new A.a4(o,A.p(o).h("a4<1>"))),new A.o4(),A.u([],t.az),A.T(t.S,t.lp),new A.dW(A.nO(n)),new A.dW(A.nO(n))).cv()
if($.zG())A.aD(r,"connect",new A.uS(new A.uU(new A.uT(new A.pn(A.T(t.N,t.mO)),o))),!1,p)
else A.aD(r,"message",o.gc4(o),!1,p)},
uT:function uT(a,b){this.a=a
this.b=b},
uU:function uU(a){this.a=a},
uS:function uS(a){this.a=a},
rs:function rs(a,b){this.a=a
this.b=b},
o4:function o4(){},
o6:function o6(a){this.a=a},
vo(a,b){if(b<0)A.r(A.az("Offset may not be negative, was "+b+"."))
else if(b>a.c.length)A.r(A.az("Offset "+b+u.D+a.gk(0)+"."))
return new A.ir(a,b)},
oB:function oB(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
ir:function ir(a,b){this.a=a
this.b=b},
er:function er(a,b,c){this.a=a
this.b=b
this.c=c},
AB(a,b){var s=A.AC(A.u([A.C5(a,!0)],t.g7)),r=new A.nv(b).$0(),q=B.b.j(B.c.gaQ(s).b+1),p=A.AD(s)?0:3,o=A.a5(s)
return new A.nb(s,r,null,1+Math.max(q.length,p),new A.a8(s,new A.nd(),o.h("a8<1,c>")).oR(0,B.aM),!A.EF(new A.a8(s,new A.ne(),o.h("a8<1,k?>"))),new A.a0(""))},
AD(a){var s,r,q
for(s=0;s<a.length-1;){r=a[s];++s
q=a[s]
if(r.b+1!==q.b&&J.A(r.c,q.c))return!1}return!0},
AC(a){var s,r,q=A.Ev(a,new A.ng(),t.nf,t.K)
for(s=new A.b6(q,q.r,q.e);s.m();)J.wA(s.d,new A.nh())
s=A.p(q).h("aG<1,2>")
r=s.h("fc<n.E,by>")
s=A.ap(new A.fc(new A.aG(q,s),new A.ni(),r),r.h("n.E"))
return s},
C5(a,b){var s=new A.rQ(a).$0()
return new A.aP(s,!0,null)},
C7(a){var s,r,q,p,o,n,m=a.gah()
if(!B.a.U(m,"\r\n"))return a
s=a.gC().ga8()
for(r=m.length-1,q=0;q<r;++q)if(m.charCodeAt(q)===13&&m.charCodeAt(q+1)===10)--s
r=a.gG()
p=a.gM()
o=a.gC().gW()
p=A.jb(s,a.gC().ga7(),o,p)
o=A.hM(m,"\r\n","\n")
n=a.gaH()
return A.oC(r,p,o,A.hM(n,"\r\n","\n"))},
C8(a){var s,r,q,p,o,n,m
if(!B.a.bF(a.gaH(),"\n"))return a
if(B.a.bF(a.gah(),"\n\n"))return a
s=B.a.t(a.gaH(),0,a.gaH().length-1)
r=a.gah()
q=a.gG()
p=a.gC()
if(B.a.bF(a.gah(),"\n")){o=A.uG(a.gaH(),a.gah(),a.gG().ga7())
o.toString
o=o+a.gG().ga7()+a.gk(a)===a.gaH().length}else o=!1
if(o){r=B.a.t(a.gah(),0,a.gah().length-1)
if(r.length===0)p=q
else{o=a.gC().ga8()
n=a.gM()
m=a.gC().gW()
p=A.jb(o-1,A.xU(s),m-1,n)
q=a.gG().ga8()===a.gC().ga8()?p:a.gG()}}return A.oC(q,p,r,s)},
C6(a){var s,r,q,p,o
if(a.gC().ga7()!==0)return a
if(a.gC().gW()===a.gG().gW())return a
s=B.a.t(a.gah(),0,a.gah().length-1)
r=a.gG()
q=a.gC().ga8()
p=a.gM()
o=a.gC().gW()
p=A.jb(q-1,s.length-B.a.cA(s,"\n")-1,o-1,p)
return A.oC(r,p,s,B.a.bF(a.gaH(),"\n")?B.a.t(a.gaH(),0,a.gaH().length-1):a.gaH())},
xU(a){var s=a.length
if(s===0)return 0
else if(a.charCodeAt(s-1)===10)return s===1?0:s-B.a.em(a,"\n",s-2)-1
else return s-B.a.cA(a,"\n")-1},
nb:function nb(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
nv:function nv(a){this.a=a},
nd:function nd(){},
nc:function nc(){},
ne:function ne(){},
ng:function ng(){},
nh:function nh(){},
ni:function ni(){},
nf:function nf(a){this.a=a},
nw:function nw(){},
nj:function nj(a){this.a=a},
nq:function nq(a,b,c){this.a=a
this.b=b
this.c=c},
nr:function nr(a,b){this.a=a
this.b=b},
ns:function ns(a){this.a=a},
nt:function nt(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
no:function no(a,b){this.a=a
this.b=b},
np:function np(a,b){this.a=a
this.b=b},
nk:function nk(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
nl:function nl(a,b,c){this.a=a
this.b=b
this.c=c},
nm:function nm(a,b,c){this.a=a
this.b=b
this.c=c},
nn:function nn(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
nu:function nu(a,b,c){this.a=a
this.b=b
this.c=c},
aP:function aP(a,b,c){this.a=a
this.b=b
this.c=c},
rQ:function rQ(a){this.a=a},
by:function by(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jb(a,b,c,d){if(a<0)A.r(A.az("Offset may not be negative, was "+a+"."))
else if(c<0)A.r(A.az("Line may not be negative, was "+c+"."))
else if(b<0)A.r(A.az("Column may not be negative, was "+b+"."))
return new A.bv(d,a,c,b)},
bv:function bv(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jc:function jc(){},
je:function je(){},
Bo(a,b,c){return new A.e5(c,a,b)},
jf:function jf(){},
e5:function e5(a,b,c){this.c=a
this.a=b
this.b=c},
e6:function e6(){},
oC(a,b,c,d){var s=new A.c2(d,a,b,c)
s.l0(a,b,c)
if(!B.a.U(d,c))A.r(A.J('The context line "'+d+'" must contain "'+c+'".',null))
if(A.uG(d,c,a.ga7())==null)A.r(A.J('The span text "'+c+'" must start at column '+(a.ga7()+1)+' in a line within "'+d+'".',null))
return s},
c2:function c2(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
Bp(a){var s
A:{if(18===a){s=B.ak
break A}if(23===a){s=B.al
break A}if(9===a){s=B.am
break A}s=null
break A}return s},
e7:function e7(a,b){this.a=a
this.b=b},
ba:function ba(a,b,c){this.a=a
this.b=b
this.c=c},
jj(a,b,c,d,e,f,g){return new A.da(d,b,c,e,f,a,g)},
da:function da(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
oH:function oH(){},
my:function my(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=null
_.r=!1},
mH:function mH(a){this.a=a},
mG:function mG(a){this.a=a},
mI:function mI(a){this.a=a},
mE:function mE(a){this.a=a},
mD:function mD(a){this.a=a},
mF:function mF(a){this.a=a},
mA:function mA(a){this.a=a},
mz:function mz(a){this.a=a},
mB:function mB(a){this.a=a},
mC:function mC(a,b){this.a=a
this.b=b},
cC:function cC(a,b,c,d,e){var _=this
_.a=a
_.b=!1
_.c=b
_.d=null
_.e=c
_.f=d
_.w=_.r=null
_.$ti=e},
ts:function ts(a,b){this.a=a
this.b=b},
tt:function tt(a,b,c){this.a=a
this.b=b
this.c=c},
tu:function tu(a,b,c){this.a=a
this.b=b
this.c=c},
oD:function oD(){},
e8:function e8(a,b,c){var _=this
_.a=a
_.b=b
_.d=c
_.e=null
_.f=!0
_.r=!1},
vr(a,b){var s=$.kV()
return new A.it(A.T(t.N,t.a_),s,a)},
it:function it(a,b,c){this.d=a
this.b=b
this.a=c},
k_:function k_(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=0},
EO(a){var s=J.A2(new v.G.URL(a,"file:///").pathname,"/")
return new A.c7(s,new A.v3(),A.a5(s).h("c7<1>"))},
v3:function v3(){},
m6:function m6(){},
bG:function bG(a,b,c){this.d=a
this.a=b
this.c=c},
aW:function aW(a,b){this.a=a
this.b=b},
kk:function kk(a){this.a=a
this.b=-1},
kl:function kl(){},
km:function km(){},
ko:function ko(){},
kp:function kp(){},
o1:function o1(a,b){this.a=a
this.b=b},
Ba(a){var s=a.f=!1,r=a.a
r=r.c.d.sqlite3_step(r.b)
A:{if(100===r){s=!0
break A}if(101===r||0===r)break A
s=a.bw(r,"step")}return s},
cU:function cU(){},
nA:function nA(){},
f7:function f7(a){this.a=a},
dh(a){return new A.c6(a)},
wD(a,b){var s,r,q,p
if(b==null)b=$.kV()
for(s=a.length,r=a.$flags|0,q=0;q<s;++q){p=b.er(256)
r&2&&A.C(a)
a[q]=p}},
c6:function c6(a){this.a=a},
fF:function fF(a){this.a=a},
aC:function aC(){},
i2:function i2(){},
i1:function i1(){},
EU(a,b){var s=null,r=new A.d1(t.kk)
return A.EV(a,new A.fY(s,s,s,s,s,s,s,s,new A.va(new A.v9(r,A.uc(new A.vb(r)))),s,s,s,s),b)},
dj:function dj(a){var _=this
_.d=a
_.c=_.b=_.a=null},
vb:function vb(a){this.a=a},
v9:function v9(a,b){this.a=a
this.b=b},
va:function va(a){this.a=a},
q1:function q1(a,b){this.a=a
this.b=b},
pX:function pX(a,b,c){this.a=a
this.b=b
this.c=c},
q3:function q3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
q2:function q2(a,b,c){this.b=a
this.c=b
this.d=c},
di:function di(){},
cx:function cx(){},
ed:function ed(a,b,c){this.a=a
this.b=b
this.c=c},
cf(a,b){var s,r,q,p=null
try{p=a.$0()}catch(q){s=A.E(q)
r=A.I(q)
$.m.c7(s,r)
p=b}return p},
aT(a){var s,r,q,p=0
try{a.$0()}catch(r){q=A.E(r)
if(q instanceof A.c6){s=q
p=s.a}else{A.I(r)
p=1}}return p},
id:function id(a){this.b=this.a=$
this.d=a},
mh:function mh(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
md:function md(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mm:function mm(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mo:function mo(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mr:function mr(a,b){this.a=a
this.b=b},
mg:function mg(a,b,c){this.a=a
this.b=b
this.c=c},
mf:function mf(a){this.a=a},
mp:function mp(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mv:function mv(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mt:function mt(a,b){this.a=a
this.b=b},
ms:function ms(a,b){this.a=a
this.b=b},
ml:function ml(a,b,c){this.a=a
this.b=b
this.c=c},
mk:function mk(a,b,c){this.a=a
this.b=b
this.c=c},
mn:function mn(a,b){this.a=a
this.b=b},
mu:function mu(a,b){this.a=a
this.b=b},
me:function me(a,b,c){this.a=a
this.b=b
this.c=c},
mi:function mi(a){this.a=a},
mj:function mj(a,b,c){this.a=a
this.b=b
this.c=c},
mq:function mq(a){this.a=a},
mb:function mb(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mc:function mc(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
ma:function ma(a,b){this.a=a
this.b=b},
m9:function m9(a,b){this.a=a
this.b=b},
m8:function m8(a,b,c){this.a=a
this.b=b
this.c=c},
eW:function eW(a,b){this.a=a
this.$ti=b},
l5:function l5(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l7:function l7(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l6:function l6(a,b,c){this.a=a
this.b=b
this.c=c},
bD(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aD(a,"success",new A.lP(r,a,b),!1,q)
A.aD(a,"error",new A.lQ(r,a),!1,q)
return s},
Ai(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aD(a,"success",new A.lU(r,a,b),!1,q)
A.aD(a,"error",new A.lV(r,a),!1,q)
A.aD(a,"blocked",new A.lW(r),!1,q)
return s},
dn:function dn(a,b){var _=this
_.c=_.b=_.a=null
_.d=a
_.$ti=b},
rh:function rh(a,b){this.a=a
this.b=b},
ri:function ri(a,b){this.a=a
this.b=b},
lP:function lP(a,b,c){this.a=a
this.b=b
this.c=c},
lQ:function lQ(a,b){this.a=a
this.b=b},
lU:function lU(a,b,c){this.a=a
this.b=b
this.c=c},
lV:function lV(a,b){this.a=a
this.b=b},
lW:function lW(a){this.a=a},
vc(){var s=v.G.navigator
if("storage" in s)return s.storage
return null},
wT(a,b,c){var s=a.read(b,c)
return s},
wU(a,b,c){var s=a.write(b,c)
return s},
Ax(a){var s=t.om
if(!(v.G.Symbol.asyncIterator in a))A.r(A.J("Target object does not implement the async iterable interface",null))
return new A.aM(new A.mX(),new A.eW(a,s),s.h("aM<D.T,v>"))},
mX:function mX(){},
pY:function pY(a){this.a=a},
pZ:function pZ(a){this.a=a},
q0(a,b){var s=0,r=A.i(t.w),q,p,o
var $async$q0=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p=v.G
o=A
s=3
return A.b(A.ar(p.fetch(new p.URL(a,A.S(p.location).href),null),t.m),$async$q0)
case 3:q=o.q_(d,null)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$q0,r)},
q_(a,b){var s=0,r=A.i(t.w),q,p,o,n,m
var $async$q_=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p=new A.id(A.T(t.S,t.ie))
o=A
n=A
m=A
s=3
return A.b(new A.pY(p).eo(a),$async$q_)
case 3:q=new o.ec(new n.q1(m.BH(d,p),new A.io(new WeakMap())))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$q_,r)},
ec:function ec(a){this.a=a},
C9(a){var s=new A.hd(a,new A.N(new A.l($.m,t.D),t.F),a.objectStore("files"),a.objectStore("blocks"))
s.l7(a)
return s},
iv(a,b,c){var s=0,r=A.i(t.cF),q,p,o,n,m,l
var $async$iv=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:p=t.N
o=new A.lc(a)
n=A.vr("dart-memory",null)
m=$.kV()
l=new A.cl(o,n,new A.d1(t.p3),A.bs(p),A.T(p,t.S),m,b)
l.r=!1
s=3
return A.b(o.es(),$async$iv)
case 3:s=4
return A.b(l.d_(),$async$iv)
case 4:q=l
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$iv,r)},
lc:function lc(a){this.a=null
this.b=a},
lf:function lf(a){this.a=a},
le:function le(a,b,c){this.a=a
this.b=b
this.c=c},
ld:function ld(a){this.a=a},
hd:function hd(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=!1
_.d=c
_.e=d},
rT:function rT(a){this.a=a},
rU:function rU(a){this.a=a},
rS:function rS(a){this.a=a},
rV:function rV(a,b,c){this.a=a
this.b=b
this.c=c},
rX:function rX(a,b){this.a=a
this.b=b},
rW:function rW(a,b){this.a=a
this.b=b},
rw:function rw(a,b,c){this.a=a
this.b=b
this.c=c},
rx:function rx(a,b){this.a=a
this.b=b},
k7:function k7(a,b){this.a=a
this.b=b},
cl:function cl(a,b,c,d,e,f,g){var _=this
_.d=a
_.e=!1
_.f=null
_.r=!0
_.w=b
_.x=c
_.y=d
_.z=e
_.b=f
_.a=g},
ny:function ny(a,b,c){this.a=a
this.b=b
this.c=c},
nz:function nz(){},
nx:function nx(a,b){this.a=a
this.b=b},
k0:function k0(a,b,c){this.a=a
this.b=b
this.c=c},
rR:function rR(a,b){this.a=a
this.b=b},
aE:function aE(){},
hb:function hb(a,b){var _=this
_.w=a
_.d=b
_.c=_.b=_.a=null},
h6:function h6(a,b,c){var _=this
_.w=a
_.x=b
_.d=c
_.c=_.b=_.a=null},
em:function em(a,b,c){var _=this
_.w=a
_.x=b
_.d=c
_.c=_.b=_.a=null},
eG:function eG(a,b,c,d,e){var _=this
_.w=a
_.x=b
_.y=c
_.z=d
_.d=e
_.c=_.b=_.a=null},
xq(a){var s=A.vr("dart-memory",null),r=$.kV()
return new A.e4(s,r,a)},
j7(a,b){var s=0,r=A.i(t.mt),q,p,o,n,m,l,k,j
var $async$j7=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:j=A.vc()
if(j==null)throw A.a(A.dh(1))
p=t.m
s=3
return A.b(A.ar(j.getDirectory(),p),$async$j7)
case 3:o=d
n=A.EO(a),m=J.Z(n.a),n=new A.ef(m,n.b),l=null
case 4:if(!n.m()){s=6
break}s=7
return A.b(A.ar(o.getDirectoryHandle(m.gp(),{create:!0}),p),$async$j7)
case 7:k=d
case 5:l=o,o=k
s=4
break
case 6:q=new A.Q(l,o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$j7,r)},
j8(a){var s=0,r=A.i(t.m),q
var $async$j8=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.j7(a,!0),$async$j8)
case 3:q=c.b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$j8,r)},
oz(a,b){var s=0,r=A.i(t.g_),q,p
var $async$oz=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:if(A.vc()==null)throw A.a(A.dh(1))
p=A
s=3
return A.b(A.j8(a),$async$oz)
case 3:q=p.oy(d,!1,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$oz,r)},
oy(a,b,c){var s=0,r=A.i(t.g_),q,p
var $async$oy=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:p=A.xq(c)
s=3
return A.b(p.bL(a,!1),$async$oy)
case 3:q=p
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$oy,r)},
dO:function dO(a,b,c){this.c=a
this.a=b
this.b=c},
e4:function e4(a,b,c){var _=this
_.d=null
_.e=a
_.b=b
_.a=c},
oA:function oA(a,b){this.a=a
this.b=b},
kq:function kq(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=0},
ta:function ta(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
BH(a,b){var s=A.S(a.exports.memory)
b.b!==$&&A.zd()
b.b=s
s=new A.pS(s,b,a.exports)
s.l3(a,b)
return s},
vM(a,b){var s,r=A.aV(a.buffer,b,null)
for(s=0;r[s]!==0;)++s
return s},
eg(a,b,c){var s=a.buffer
return B.l.aI(A.aV(s,b,c==null?A.vM(a,b):c))},
vL(a,b,c){var s
if(b===0)return null
s=a.buffer
return B.l.aI(A.aV(s,b,c==null?A.vM(a,b):c))},
pS:function pS(a,b,c){var _=this
_.b=a
_.c=b
_.d=c
_.w=_.r=null},
pT:function pT(a){this.a=a},
pU:function pU(a){this.a=a},
pV:function pV(a){this.a=a},
pW:function pW(a){this.a=a},
uD(){var s=0,r=A.i(t.ja),q,p,o,n,m,l
var $async$uD=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:m=new v.G.MessageChannel()
l=$.hO()
s=l!=null?3:5
break
case 3:p=A.Dz()
s=6
return A.b(A.ee(l,p,null,null,!1),$async$uD)
case 6:o=b
s=4
break
case 5:o=null
p=null
case 4:n=m.port2
q=new A.Q({port:m.port1,lockName:p},new A.dJ(n,p,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$uD,r)},
Dz(){var s,r
for(s=0,r="channel-close-";s<16;++s)r+=A.aR(97+$.zM().er(26))
return r.charCodeAt(0)==0?r:r},
A9(a){return new A.f_(a)},
dJ:function dJ(a,b,c){this.a=a
this.b=b
this.c=c},
o8:function o8(){},
oc:function oc(a){this.a=a},
od:function od(a){this.a=a},
ob:function ob(a){this.a=a},
oa:function oa(a){this.a=a},
o9:function o9(a){this.a=a},
oe:function oe(a,b,c){this.a=a
this.b=b
this.c=c},
f_:function f_(a){this.a=a},
Bc(a,b){var s=t.H
s=new A.j3(a,b,new A.aa(new A.l($.m,t.ny),t.mE),A.c3(!1,t.e1),new A.jQ(A.c3(!1,s)),new A.jQ(A.c3(!1,s)))
s.kZ(a,b)
return s},
BJ(a,b){var s=t.m,r=A.c3(!1,s),q=new A.l($.m,t.D),p=t.S
s=new A.jD(r,b,a.a,new A.aa(q,t.h),A.T(p,t.br),A.T(p,s))
s.hC(a)
q.J(r.gaG())
return s},
Ap(a,b,c,d){var s=A.nO(t.cj)
return new A.mw(d,new A.dW(s),A.bs(t.jC))},
jQ:function jQ(a){this.a=null
this.b=a},
j3:function j3(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.e=d
_.f=e
_.r=f},
om:function om(a){this.a=a},
on:function on(a){this.a=a},
oi:function oi(a){this.a=a},
oo:function oo(a){this.a=a},
op:function op(a){this.a=a},
oq:function oq(a){this.a=a},
ok:function ok(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
oj:function oj(a,b,c){this.a=a
this.b=b
this.c=c},
ol:function ol(a,b,c){this.a=a
this.b=b
this.c=c},
jD:function jD(a,b,c,d,e,f){var _=this
_.w=a
_.x=b
_.a=c
_.b=d
_.d=_.c=null
_.e=0
_.f=e
_.r=f},
mw:function mw(a,b,c){this.d=a
this.e=b
this.z=c},
mx:function mx(){},
ic:function ic(a){this.a=a},
m7:function m7(a,b){this.c=a
this.a=b},
cy:function cy(){},
ro:function ro(){},
iq(a,b,c){var s=0,r=A.i(t.eZ),q,p,o
var $async$iq=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=3
return A.b(A.j8(a),$async$iq)
case 3:p=e
o=A.xq(c)
s=b?4:5
break
case 4:s=6
return A.b(o.bL(p,!0),$async$iq)
case 6:case 5:q=new A.ip(o,p,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$iq,r)},
ip:function ip(a,b,c){this.a=a
this.b=b
this.c=c},
na:function na(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=0},
ee(a,b,c,d,e){var s,r,q={},p=new A.l($.m,t.fV),o=new A.N(p,t.l6)
q.a=null
s={steal:e}
if(c!=null)s.signal=c
r=t.X
A.is(A.ar(a.request(b,s,A.bB(new A.qa(q,o))),r),new A.qb(q,d,o),r,t.K)
return p},
qa:function qa(a,b){this.a=a
this.b=b},
qb:function qb(a,b,c){this.a=a
this.b=b
this.c=c},
bV:function bV(a){this.a=a},
ie:function ie(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=null},
mK:function mK(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mJ:function mJ(a,b){this.a=a
this.b=b},
mL:function mL(a){this.a=a},
dW:function dW(a){this.a=!1
this.b=a},
o0:function o0(a,b){this.a=a
this.b=b},
o_:function o_(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
nZ:function nZ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
Af(a){var s,r,q,p,o=A.u([],t.kC),n=t.c.a(a.a),m=t.k.b(n)?n:new A.ag(n,A.a5(n).h("ag<1,j>"))
for(s=J.ab(m),r=0;r<s.gk(m)/2;++r){q=r*2
o.push(new A.Q(A.mV(B.by,s.i(m,q)),s.i(m,q+1)))}s=A.aY(a.b)
q=A.aY(a.c)
p=A.aY(a.d)
return new A.cV(o,s,q,A.aY(a.g),p)},
cV:function cV(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
Bf(a){var s
if(J.A(a.t,"errorResponse")){s=A.As(a)
if(s!=null&&s instanceof A.bq)return s
else return new A.d6(a.e,s)}else return new A.d6("Did not respond with expected type, got "+A.q(a),null)},
As(a){var s=a.s,r=s==null?null:A.R(s)
A:{if(0===r){s=A.At(t.c.a(a.r))
break A}if(1===r){s=B.B
break A}s=null
break A}return s},
At(a){var s,r,q,p,o=null,n=a.length>=8,m=o,l=o,k=o,j=o,i=o,h=o,g=o
if(n){s=a[0]
m=a[1]
l=a[2]
k=a[3]
j=a[4]
i=a[5]
h=a[6]
g=a[7]}else s=o
if(!n)throw A.a(A.z("Pattern matching error"))
n=new A.mW()
l=A.R(A.bA(l))
A.al(s)
r=n.$1(m)
q=n.$1(j)
if(i!=null&&h!=null){t.c.a(i)
t.a.a(h)
p=new A.cj(i,h,A.aV(h,0,o))}else p=o
n=n.$1(k)
A.yn(g)
return new A.da(s,r,l,g==null?o:A.R(g),n,q,p)},
Au(a){var s,r,q,p,o,n,m=null,l=a.r
A:{if(l==null){s=m
break A}s=A.vH(l)
break A}r=a.b
if(r==null)r=m
q=a.e
if(q==null)q=m
p=a.f
if(p==null)p=m
o=s==null
n=o?m:s.a
s=o?m:s.b
o=a.d
if(o==null)o=m
return[a.a,r,a.c,q,p,n,s,o]},
Bg(a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=null,a1=v.G,a2=new a1.Array(),a3=new a1.ArrayBuffer(512),a4=new A.na(a3,512,"transfer" in a3)
a6.j3(a5)
for(s=a5.a,r=s.c,q=s.b,p=r.d,r=r.b,o=0,n=!0;A.Ba(a5);){if(n){o=p.sqlite3_column_count(q)
n=!1}m=a4.d
l=a4.d=m+o
if(l>a4.b)a4.lU(l)
l=new a1.DataView(a4.a,m,o)
k=new a1.Array(o)
for(j=0;j<o;++j){switch(p.sqlite3_column_type(q,j)){case 1:i=p.sqlite3_column_int64(q,j)
h=a1.Number(i)
if(a1.Number.isSafeInteger(h)){i=h
g=B.U}else g=B.V
break
case 2:i=p.sqlite3_column_double(q,j)
g=B.W
break
case 3:f=p.sqlite3_column_text(q,j)
e=p.sqlite3_column_bytes(q,j)
d=r.buffer
f=new Uint8Array(d,f,e)
c=new A.cF(!1).cU(f,0,a0,!0)
i=c
g=B.X
break
case 4:f=p.sqlite3_column_bytes(q,j)
b=new Uint8Array(f)
e=p.sqlite3_column_bytes(q,j)
A.aJ(0,e,f)
s.kG(j,b,0,e)
i=b
g=B.Y
break
case 5:default:i=a0
g=B.Z}k[j]=i
l.setUint8(j,g.a)}a2.push(k)}a=new a1.Array(o)
for(j=0;j<o;++j){a1=p.sqlite3_column_name(q,j)
s=r.buffer
l=A.vM(r,a1)
a1=new Uint8Array(s,a1,l)
a[j]=new A.cF(!1).cU(a1,0,a0,!0)}return A.z4(!1,a,0,0,a2,a0,a4.oZ(0))},
Bh(a){var s,r,q,p,o,n,m,l,k,j,i,h=a.c
if(h!=null){s=t.k.b(h)?h:new A.ag(h,A.a5(h).h("ag<1,j>"))
s=J.dE(s,new A.ou(),t.N)
r=A.ap(s,s.$ti.h("X.E"))
s=a.n
if(s!=null){s=t.fi.b(s)?s:new A.ag(s,A.a5(s).h("ag<1,j?>"))
s=J.dE(s,new A.ov(),t.T)
A.ap(s,s.$ti.h("X.E"))}s=a.v
q=s==null?null:A.aV(s,0,null)
p=A.u([],t.dO)
s=a.r
s.toString
if(!t.mu.b(s))s=new A.ag(s,A.a5(s).h("ag<1,w<k?>>"))
s=J.Z(s)
o=q!=null
n=0
while(s.m()){m=s.gp()
l=[]
m=B.c.gA(m)
while(m.m()){k=m.gp()
if(o){j=q[n]
i=j>=8?B.x:B.I[j]}else i=B.x
l.push(i.je(k));++n}p.push(l)}s=new A.bG(p,r,B.bA)
s.lj()
return s}else return null},
EG(a){if(a==="sharedCompatibilityCheck"||a==="dedicatedCompatibilityCheck"||a==="dedicatedInSharedCompatibilityCheck")return!0
else return!1},
mW:function mW(){},
ou:function ou(){},
ov:function ov(){},
z4(a,b,c,d,e,f,g){return{c:b,n:f,v:g,r:e,x:a,y:c,i:d,t:"rowsResponse"}},
dA(a){var s,r,q,p,o=v.G,n=new o.Array()
switch(a.t){case"connect":n.push(a.r.port)
break
case"fileSystemAccess":s=a.b
if(s!=null)n.push(s)
break
case"runQuery":n.push(a.v)
break
case"simpleSuccessResponse":r=a.r
if(r!=null){o=o.ArrayBuffer
o=r instanceof o
q=r}else{q=null
o=!1}if(o)n.push(q)
break
case"endpointResponse":n.push(a.r.port)
break
case"rowsResponse":p=a.v
if(p!=null)n.push(p)
break}return n},
En(a,b,c,d,e){switch(a.t){case"abort":return b.$1(a)
case"notifyUpdate":case"notifyCommit":case"notifyRollback":return c.$1(a)
case"simpleSuccessResponse":case"endpointResponse":case"rowsResponse":case"errorResponse":return e.$1(a)
default:return d.$1(a)}},
fu:function fu(a,b){this.a=a
this.b=b},
ot:function ot(){},
Ay(a){var s,r
for(s=0;s<5;++s){r=B.bt[s]
if(r.c===a)return r}throw A.a(A.J("Unknown FS implementation: "+a,null))},
Bw(a){var s,r,q,p,o,n,m,l,k,j=null
A:{if(a==null){s=j
r=B.Z
break A}q=A.hH(a)
p=q?a:j
if(q){s=p
r=B.U
break A}q=a instanceof A.aA
if(q)o=a
else o=j
if(q){s=v.G.BigInt(o.j(0))
r=B.V
break A}q=typeof a=="number"
n=q?a:j
if(q){s=n
r=B.W
break A}q=typeof a=="string"
m=q?a:j
if(q){s=m
r=B.X
break A}q=t.p.b(a)
l=q?a:j
if(q){s=l
r=B.Y
break A}q=A.kN(a)
k=q?a:j
if(q){s=k
r=B.aE
break A}throw A.a(A.J("Unsupported value: "+A.q(a),j))}return new A.Q(r,s)},
vH(a){var s,r,q,p,o,n
if(a instanceof A.cj)return new A.Q(a.a,a.b)
s=[]
r=J.ab(a)
q=r.gk(a)
p=new Uint8Array(q)
for(o=0;o<r.gk(a);++o){n=A.Bw(r.i(a,o))
p[o]=n.a.a
s.push(n.b)}return new A.Q(s,t.a.a(B.f.gar(p)))},
ck:function ck(a,b,c){this.c=a
this.a=b
this.b=c},
bw:function bw(a,b){this.a=a
this.b=b},
cj:function cj(a,b,c){this.a=a
this.b=b
this.c=c},
kQ(){var s=0,r=A.i(t.y),q,p=2,o=[],n=[],m,l,k,j,i,h
var $async$kQ=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:i=v.G
if(!("indexedDB" in i)||!("FileReader" in i)){q=!1
s=1
break}m=A.S(i.indexedDB)
i=$.hO()
i=i==null?null:A.ee(i,"drift_mock_db",null,null,!1)
s=3
return A.b(t.fP.b(i)?i:A.bM(i,t.b3),$async$kQ)
case 3:l=b
p=5
s=8
return A.b(A.Ah(m.open("drift_mock_db"),t.m),$async$kQ)
case 8:k=b
k.close()
m.deleteDatabase("drift_mock_db")
n.push(7)
s=6
break
case 5:p=4
h=o.pop()
q=!1
n=[1]
s=6
break
n.push(7)
s=6
break
case 4:n=[2]
case 6:p=2
i=l
if(i!=null)i.a.L()
s=n.pop()
break
case 7:q=!0
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$kQ,r)},
uB(a){return A.Ee(a)},
Ee(a){var s=0,r=A.i(t.y),q,p=2,o=[],n,m,l,k,j,i
var $async$uB=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:j={}
j.a=null
p=4
n=A.S(v.G.indexedDB)
m=n.open(a,1)
m.onupgradeneeded=A.bB(new A.uC(j,m))
s=7
return A.b(A.Ag(m,t.m),$async$uB)
case 7:l=c
if(j.a==null)j.a=!0
l.close()
p=2
s=6
break
case 4:p=3
i=o.pop()
s=6
break
case 3:s=2
break
case 6:j=j.a
q=j===!0
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$uB,r)},
eS(){var s=0,r=A.i(t.k),q,p=2,o=[],n=[],m,l,k,j,i,h,g
var $async$eS=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:h=A.vc()
if(h==null){q=B.J
s=1
break}j=t.m
s=3
return A.b(A.ar(h.getDirectory(),j),$async$eS)
case 3:m=b
p=5
s=8
return A.b(A.ar(m.getDirectoryHandle("drift_db",{create:!1}),j),$async$eS)
case 8:m=b
p=2
s=7
break
case 5:p=4
g=o.pop()
q=B.J
s=1
break
s=7
break
case 4:s=2
break
case 7:l=A.u([],t.s)
j=new A.bP(A.bd(A.Ax(m),"stream",t.K))
p=9
case 12:s=14
return A.b(j.m(),$async$eS)
case 14:if(!b){s=13
break}k=j.gp()
if(J.A(k.kind,"directory"))J.hP(l,k.name)
s=12
break
case 13:n.push(11)
s=10
break
case 9:n=[2]
case 10:p=2
s=15
return A.b(j.u(),$async$eS)
case 15:s=n.pop()
break
case 11:q=l
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$eS,r)},
Ag(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aD(a,"success",new A.lN(r,a,b),!1,q)
A.aD(a,"error",new A.lO(r,a),!1,q)
return s},
Ah(a,b){var s=new A.l($.m,b.h("l<0>")),r=new A.N(s,b.h("N<0>")),q=t.m
A.aD(a,"success",new A.lR(r,a,b),!1,q)
A.aD(a,"error",new A.lS(r,a),!1,q)
A.aD(a,"blocked",new A.lT(r,a),!1,q)
return s},
uC:function uC(a,b){this.a=a
this.b=b},
lN:function lN(a,b,c){this.a=a
this.b=b
this.c=c},
lO:function lO(a,b){this.a=a
this.b=b},
lR:function lR(a,b,c){this.a=a
this.b=b
this.c=c},
lS:function lS(a,b){this.a=a
this.b=b},
lT:function lT(a,b){this.a=a
this.b=b},
o7:function o7(a,b){this.a=a
this.b=b},
fe:function fe(a,b){this.a=a
this.b=b},
cv:function cv(a,b){this.a=a
this.b=b},
d6:function d6(a,b){this.a=a
this.b=b},
bq:function bq(a,b){this.a=a
this.b=b},
rp:function rp(a){this.a=a},
tO:function tO(){},
rn:function rn(a){this.a=a},
D5(a){var s=a.goi()
return new A.aM(new A.ua(),s,A.p(s).h("aM<D.T,v>"))},
xP(a,b){var s=A.u([],t.kG),r=b==null?a.b:b
return new A.ek(a,r,new A.hv(),new A.hv(),new A.hv(),s)},
C0(a,b,c){var s=t.S
s=new A.ej(c,A.u([],t.ba),a.a,new A.aa(new A.l($.m,t.D),t.h),A.T(s,t.br),A.T(s,t.m))
s.hC(a)
s.l6(a,b,c)
return s},
yu(a){var s
switch(a.a){case 0:s="/database"
break
case 1:s="/database-journal"
break
default:s=null}return s},
ua:function ua(){},
hv:function hv(){this.a=null},
ek:function ek(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=null
_.r=1
_.w=f},
rc:function rc(a){this.a=a},
rg:function rg(a,b){this.a=a
this.b=b},
rd:function rd(a,b){this.a=a
this.b=b},
re:function re(a){this.a=a},
rf:function rf(a,b){this.a=a
this.b=b},
ej:function ej(a,b,c,d,e,f){var _=this
_.w=a
_.x=b
_.a=c
_.b=d
_.d=_.c=null
_.e=0
_.f=e
_.r=f},
r0:function r0(a){this.a=a},
r3:function r3(a,b,c){this.a=a
this.b=b
this.c=c},
r6:function r6(a,b){this.a=a
this.b=b},
r9:function r9(a,b,c){this.a=a
this.b=b
this.c=c},
r2:function r2(a,b){this.a=a
this.b=b},
r1:function r1(a,b){this.a=a
this.b=b},
r8:function r8(a,b){this.a=a
this.b=b},
r7:function r7(a,b){this.a=a
this.b=b},
rb:function rb(a,b){this.a=a
this.b=b},
ra:function ra(a,b){this.a=a
this.b=b},
r4:function r4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
r5:function r5(a,b){this.a=a
this.b=b},
r_:function r_(a){this.a=a},
ig:function ig(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=1
_.Q=_.z=_.y=_.x=null},
mO:function mO(a){this.a=a},
mN:function mN(a){this.a=a},
mM:function mM(a,b){this.a=a
this.b=b},
qp:function qp(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=0
_.e=d
_.f=0
_.w=_.r=null
_.x=e
_.y=f
_.Q=$},
qq:function qq(a,b){this.a=a
this.b=b},
qr:function qr(a,b){this.a=a
this.b=b},
qs:function qs(a){this.a=a},
Cs(){return new A.tj(A.jX(new A.tk(),t.z))},
iJ:function iJ(a){this.a=a},
tj:function tj(a){this.a=null
this.b=a},
tk:function tk(){},
to:function to(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
tl:function tl(a,b){this.a=a
this.b=b},
tm:function tm(a){this.a=a},
tp:function tp(a,b){this.a=a
this.b=b},
tn:function tn(a){this.a=a},
jh:function jh(){},
ji:function ji(){},
oG:function oG(a,b,c){this.a=a
this.b=b
this.c=c},
bC:function bC(a){this.a=a},
ow(a,b,c){return A.Bj(a,b,c,c)},
Bj(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m,l
var $async$ow=A.d(function(e,f){if(e===1){o.push(f)
s=p}for(;;)switch(s){case 0:l=new A.fC(a)
p=3
s=6
return A.b(b.$1(l),$async$ow)
case 6:m=f
q=m
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
l.c=!0
s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$ow,r)},
Bk(a){var s
A:{if(0===a){s=B.bE
break A}s=""+a
s=new A.hr("SAVEPOINT s"+s,"RELEASE s"+s,"ROLLBACK TO s"+s)
break A}return s},
fE(a,b,c){return A.Bl(a,b,c,c)},
Bl(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m,l
var $async$fE=A.d(function(e,f){if(e===1){o.push(f)
s=p}for(;;)switch(s){case 0:l=new A.fD(0,a)
p=3
s=6
return A.b(b.$1(l),$async$fE)
case 6:m=f
s=7
return A.b(a.eb(),$async$fE)
case 7:q=m
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
l.c=!0
s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$fE,r)},
jt:function jt(){},
fC:function fC(a){this.a=a
this.c=this.b=!1},
fD:function fD(a,b){var _=this
_.d=a
_.a=b
_.c=_.b=!1},
jg:function jg(){},
oE:function oE(a,b){this.a=a
this.b=b},
oF:function oF(a,b){this.a=a
this.b=b},
By(a){return new A.K(a)},
BA(a,b,c){return A.DR(new A.pL(),c,a,!0,b,t.d)},
Bz(a){var s,r=A.bs(t.N)
for(s=0;s<1;++s)r.q(0,a[s].toLowerCase())
return new A.kr(new A.pK(r))},
DR(a,b,c,d,e,f){return new A.bz(!1,new A.ur(e,a,c,b,!0,f),f.h("bz<0>"))},
K:function K(a){this.a=a},
pL:function pL(){},
pK:function pK(a){this.a=a},
pJ:function pJ(a){this.a=a},
ur:function ur(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
us:function us(a,b){this.a=a
this.b=b},
ut:function ut(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
un:function un(a,b,c){this.a=a
this.b=b
this.c=c},
um:function um(a,b){this.a=a
this.b=b},
uu:function uu(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
uw:function uw(a,b){this.a=a
this.b=b},
uv:function uv(a,b){this.a=a
this.b=b},
uo:function uo(a){this.a=a},
up:function up(a,b,c){this.a=a
this.b=b
this.c=c},
uq:function uq(a,b){this.a=a
this.b=b},
xA(a,b,c,d,e,f){var s
if(a==null)return c.$0()
s=A.ER(b,d,e)
a.pX(s.a,s.b)
return A.dP(c,f).J(new A.pz(a))},
ER(a,b,c){var s,r,q,p,o,n,m=t.z
m=A.T(m,m)
m.l(0,"sql",c)
s=[]
for(r=b.length,q=t.j,p=0;p<b.length;b.length===r||(0,A.a6)(b),++p){o=b[p]
A:{if(q.b(o)){n="<blob>"
break A}if(o instanceof A.aA){n=o.j(0)
break A}n=o
break A}s.push(n)}m.l(0,"parameters",s)
return new A.Q("sqlite_async:"+a+" "+c,m)},
pz:function pz(a){this.a=a},
eQ(a,b,c,d){return A.EE(a,b,c,d,d)},
EE(a,b,c,d,e){var s=0,r=A.i(e),q,p=2,o=[],n,m,l,k,j
var $async$eQ=A.d(function(f,g){if(f===1){o.push(g)
s=p}for(;;)switch(s){case 0:p=4
s=7
return A.b(a.eM(c?"BEGIN IMMEDIATE":"BEGIN"),$async$eQ)
case 7:s=8
return A.b(b.$1(a),$async$eQ)
case 8:n=g
s=9
return A.b(a.eM("END TRANSACTION"),$async$eQ)
case 9:q=n
s=1
break
p=2
s=6
break
case 4:p=3
k=o.pop()
p=11
s=14
return A.b(a.eM("ROLLBACK"),$async$eQ)
case 14:p=3
s=13
break
case 11:p=10
j=o.pop()
s=13
break
case 10:s=3
break
case 13:throw k
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$eQ,r)},
xz(a){var s={},r=A.u([],t.jI),q=A.bs(t.N)
s.a=A.u([],t.bO)
return new A.bz(!0,new A.pw(new A.pr(s,r,a,new A.px(q),new A.pu(r,q),new A.pv(q)),new A.py(s,r)),t.cn)},
px:function px(a){this.a=a},
pu:function pu(a,b){this.a=a
this.b=b},
pv:function pv(a){this.a=a},
pr:function pr(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
ps:function ps(a){this.a=a},
pt:function pt(a){this.a=a},
py:function py(a,b){this.a=a
this.b=b},
pw:function pw(a,b){this.a=a
this.b=b},
pq:function pq(a,b){this.a=a
this.b=b},
dv:function dv(a,b){this.a=a
this.b=b},
kU(a,b){return A.F5(a,b,b)},
F5(a,b,c){var s=0,r=A.i(c),q,p=2,o=[],n,m,l,k,j,i,h
var $async$kU=A.d(function(d,e){if(d===1){o.push(e)
s=p}for(;;)switch(s){case 0:p=4
s=7
return A.b(a.$0(),$async$kU)
case 7:j=e
q=j
s=1
break
p=2
s=6
break
case 4:p=3
h=o.pop()
j=A.E(h)
if(j instanceof A.d6){n=j
m=n.b
l=null
if(m!=null){l=m
throw A.a(l)}if(B.a.U(n.a,"Database is not in a transaction"))throw A.a(A.jj(null,null,0,"Transaction rolled back by earlier statement. Cannot execute.",null,null,null))
if(B.a.U("Remote error: "+n.a,"SqliteException")){k=A.au("SqliteException\\((\\d+)\\)",!0)
j=k.jl(n.a)
j=j==null?null:j.i(0,1)
throw A.a(A.jj(null,null,A.z_(j==null?"0":j),n.a,null,null,null))}throw h}else throw h
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$kU,r)},
D6(a,b,c){return A.is(a,new A.ub(b),c,t.fN)},
jA:function jA(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
q6:function q6(a,b){this.a=a
this.b=b},
q9:function q9(a,b){this.a=a
this.b=b},
q8:function q8(a,b){this.a=a
this.b=b},
q7:function q7(a,b){this.a=a
this.b=b},
q4:function q4(a,b,c){this.a=a
this.b=b
this.c=c},
q5:function q5(a,b,c){this.a=a
this.b=b
this.c=c},
cd:function cd(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=!1},
tI:function tI(a,b,c){this.a=a
this.b=b
this.c=c},
tH:function tH(a,b,c){this.a=a
this.b=b
this.c=c},
tG:function tG(a,b,c){this.a=a
this.b=b
this.c=c},
tF:function tF(a,b,c){this.a=a
this.b=b
this.c=c},
ub:function ub(a){this.a=a},
BZ(a){var s=a.a,r=A.p(s).h("bU<1,j>")
s=A.ap(new A.bU(s,new A.qU(),r),r.h("n.E"))
return{a:0,b:s}},
i3:function i3(a){this.b=a},
lm:function lm(){},
lk:function lk(){},
ll:function ll(){},
qU:function qU(){},
vm(a,b,c){var s=A.vH(c)
return{rawKind:a.b,rawSql:b,rawParameters:s.a,typeInfo:s.b}},
bS:function bS(a,b){this.a=a
this.b=b},
ju:function ju(a){this.a=0
this.b=a},
pG:function pG(){},
pH:function pH(a,b){this.a=a
this.b=b},
pI:function pI(a,b,c){this.a=a
this.b=b
this.c=c},
qd(a){var s=A.Cs()
return new A.qc(s,a)},
qc:function qc(a,b){this.a=a
this.b=b},
qe:function qe(a,b,c){this.a=a
this.b=b
this.c=c},
qg:function qg(a){this.a=a},
qf:function qf(){},
fi:function fi(a){this.a=a},
C1(){return new A.el()},
l8:function l8(){},
hY:function hY(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.e=d},
l9:function l9(a){this.a=a},
la:function la(a,b){this.a=a
this.b=b},
lb:function lb(a,b,c){this.a=a
this.b=b
this.c=c},
el:function el(){this.a=!1
this.b=null},
jn:function jn(a,b,c){this.c=a
this.a=b
this.b=c},
pc:function pc(a,b){var _=this
_.a=a
_.b=b
_.c=0
_.e=_.d=null},
ea:function ea(){},
k1:function k1(){},
bg:function bg(a,b){this.a=a
this.b=b},
aD(a,b,c,d,e){var s
if(c==null)s=null
else{s=A.yQ(new A.ru(c),t.m)
s=s==null?null:A.bB(s)}s=new A.eq(a,b,s,!1,e.h("eq<0>"))
s.fA()
return s},
yQ(a,b){var s=$.m
if(s===B.d)return a
return s.fK(a,b)},
vn:function vn(a,b){this.a=a
this.$ti=b},
ep:function ep(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
eq:function eq(a,b,c,d,e){var _=this
_.a=0
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
ru:function ru(a){this.a=a},
rv:function rv(a){this.a=a},
qh(a){var s=0,r=A.i(t.m1),q,p,o,n,m
var $async$qh=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=new A.ju(A.T(t.N,t.ao))
s=3
return A.b(A.Ap(B.b5,v.G.location.href,B.b2,o.gob()).fL(new A.Q(a.b,a.a)),$async$qh)
case 3:n=c
m=a.c
A:{p=null
if(m!=null){p=A.qd(m)
break A}break A}q=new A.jA(n,p,!1,o.p8(n))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$qh,r)},
zg(a){return v.mangledGlobalNames[a]},
z6(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
AO(a,b){return b in a},
vt(a,b,c,d,e,f){var s
if(c==null)return a[b]()
else if(d==null)return a[b](c)
else if(e==null)return a[b](c,d)
else{s=a[b](c,d,e)
return s}},
x_(a,b){return b in a},
Ev(a,b,c,d){var s,r,q,p,o,n=A.T(d,c.h("t<0>"))
for(s=c.h("w<0>"),r=0;r<1;++r){q=a[r]
p=b.$1(q)
o=n.i(0,p)
if(o==null){o=A.u([],s)
n.l(0,p,o)
p=o}else p=o
J.hP(p,q)}return n},
wZ(a,b){var s,r,q=A.bs(b)
for(s=a.a,s=new A.b6(s,s.r,s.e);s.m();)for(r=J.Z(s.d);r.m();)q.q(0,r.gp())
return q},
wj(a){var s,r=a.c.a.i(0,"charset")
if(a.a==="application"&&a.b==="json"&&r==null)return B.l
if(r!=null){s=A.wP(r)
if(s==null)s=B.k}else s=B.k
return s},
zf(a){return a},
ze(a){return new A.cP(a)},
F4(a,b,c){var s,r,q,p
try{q=c.$0()
return q}catch(p){q=A.E(p)
if(q instanceof A.e5){s=q
throw A.a(A.Bo("Invalid "+a+": "+s.a,s.b,s.gdK()))}else if(t.lW.b(q)){r=q
throw A.a(A.ak("Invalid "+a+' "'+b+'": '+r.gjC(),r.gdK(),r.ga8()))}else throw p}},
yW(){var s,r,q,p,o=null
try{o=A.vJ()}catch(s){if(t.L.b(A.E(s))){r=$.u8
if(r!=null)return r
throw s}else throw s}if(J.A(o,$.ys)){r=$.u8
r.toString
return r}$.ys=o
if($.wr()===$.hN())r=$.u8=o.dz(".").j(0)
else{q=o.hi()
p=q.length-1
r=$.u8=p===0?q:B.a.t(q,0,p)}return r},
z0(a){var s
if(!(a>=65&&a<=90))s=a>=97&&a<=122
else s=!0
return s},
yX(a,b){var s,r,q=null,p=a.length,o=b+2
if(p<o)return q
if(!A.z0(a.charCodeAt(b)))return q
s=b+1
if(a.charCodeAt(s)!==58){r=b+4
if(p<r)return q
if(B.a.t(a,s,r).toLowerCase()!=="%3a")return q
b=o}s=b+2
if(p===s)return s
if(a.charCodeAt(s)!==47)return q
return b+3},
Es(a){if(B.a.K(a,"ps_data_local__"))return B.a.a0(a,15)
else if(B.a.K(a,"ps_data__"))return B.a.a0(a,9)
else return null},
AE(a){var s=t.N
return t.f.a(B.h.aI(a.h)).bk(0,s,s)},
EF(a){var s,r,q,p
if(a.gk(0)===0)return!0
s=a.gai(0)
for(r=A.bK(a,1,null,a.$ti.h("X.E")),q=r.$ti,r=new A.at(r,r.gk(0),q.h("at<X.E>")),q=q.h("X.E");r.m();){p=r.d
if(!J.A(p==null?q.a(p):p,s))return!1}return!0},
ES(a,b){var s=B.c.cw(a,null)
if(s<0)throw A.a(A.J(A.q(a)+" contains no null elements.",null))
a[s]=b},
z9(a,b){var s=B.c.cw(a,b)
if(s<0)throw A.a(A.J(A.q(a)+" contains no elements matching "+b.j(0)+".",null))
a[s]=null},
Ek(a,b){var s,r,q,p
for(s=new A.br(a),r=t.V,s=new A.at(s,s.gk(0),r.h("at<y.E>")),r=r.h("y.E"),q=0;s.m();){p=s.d
if((p==null?r.a(p):p)===b)++q}return q},
uG(a,b,c){var s,r,q
if(b.length===0)for(s=0;;){r=B.a.bn(a,"\n",s)
if(r===-1)return a.length-s>=c?s:null
if(r-s>=c)return s
s=r+1}r=B.a.cw(a,b)
while(r!==-1){q=r===0?0:B.a.em(a,"\n",r-1)+1
if(c===r-q)return q
r=B.a.bn(a,b,r+1)}return null},
wi(a,b,c,d,e,f){var s,r=b.a,q=b.b,p=r.d,o=p.sqlite3_extended_errcode(q),n=p.sqlite3_error_offset(q)
A:{if(n<0){n=null
break A}break A}s=a.a
return new A.da(A.eg(r.b,p.sqlite3_errmsg(q),null),A.eg(s.b,s.d.sqlite3_errstr(o),null)+" (code "+A.q(o)+")",c,n,d,e,f)},
wp(a,b,c,d,e){throw A.a(A.wi(a.a,a.b,b,c,d,e))},
wW(a,b){var s,r
for(s=b,r=0;r<16;++r)s+=A.aR("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012346789".charCodeAt(a.er(61)))
return s.charCodeAt(0)==0?s:s},
og(a){var s=0,r=A.i(t.lo),q
var $async$og=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.ar(a.arrayBuffer(),t.a),$async$og)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$og,r)},
x9(a,b,c,d){A.vt(a,"setBigInt64",b,c,!0,null)},
cH(){var s=0,r=A.i(t.kO),q,p=2,o=[],n=[],m,l,k,j,i,h,g,f,e,d,c,b,a
var $async$cH=A.d(function(a0,a1){if(a0===1){o.push(a1)
s=p}for(;;)switch(s){case 0:b=A.vc()
if(b==null){q=B.N
s=1
break}m=null
l=null
k=null
j=null
i=!1
p=4
d=$.hO()
d=d==null?null:A.ee(d,"_drift_feature_detection",null,null,!1)
s=7
return A.b(t.fP.b(d)?d:A.bM(d,t.b3),$async$cH)
case 7:j=a1
d=t.m
s=8
return A.b(A.ar(b.getDirectory(),d),$async$cH)
case 8:m=a1
s=9
return A.b(A.ar(m.getFileHandle("_drift_feature_detection",{create:!0}),d),$async$cH)
case 9:l=a1
s=10
return A.b(A.hL(l),$async$cH)
case 10:h=a1
g=null
f=null
g=h.a
f=h.b
i=g
k=f
e=A.vt(k,"getSize",null,null,null,null)
s=typeof e==="object"?11:12
break
case 11:s=13
return A.b(A.ar(A.S(e),t.X),$async$cH)
case 13:q=B.N
n=[1]
s=5
break
case 12:g=i
q=new A.hp(!0,g)
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:p=3
a=o.pop()
q=B.N
n=[1]
s=5
break
n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
g=j
if(g!=null)g.a.L()
if(k!=null)k.close()
s=m!=null&&l!=null?14:15
break
case 14:s=16
return A.b(A.ar(m.removeEntry("_drift_feature_detection",{recursive:!1}),t.X),$async$cH)
case 16:case 15:s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$cH,r)},
hL(a){return A.DS(a)},
DS(a){var s=0,r=A.i(t.mk),q,p=2,o=[],n,m,l,k,j,i
var $async$hL=A.d(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:j=null
p=4
l=t.m
s=7
return A.b(A.ar(a.createSyncAccessHandle({mode:"readwrite-unsafe"}),l),$async$hL)
case 7:j=c
s=8
return A.b(A.ar(a.createSyncAccessHandle({mode:"readwrite-unsafe"}),l),$async$hL)
case 8:n=c
n.close()
l=j
q=new A.Q(!0,l)
s=1
break
p=2
s=6
break
case 4:p=3
i=o.pop()
l=j
if(l!=null)l.close()
s=9
return A.b(A.ar(a.createSyncAccessHandle(),t.m),$async$hL)
case 9:m=c
q=new A.Q(!1,m)
s=1
break
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$hL,r)}},B={}
var w=[A,J,B]
var $={}
A.vv.prototype={}
J.ix.prototype={
D(a,b){return a===b},
gv(a){return A.e0(a)},
j(a){return"Instance of '"+A.j_(a)+"'"},
ga4(a){return A.bm(A.wb(this))}}
J.iz.prototype={
j(a){return String(a)},
gv(a){return a?519018:218159},
ga4(a){return A.bm(t.y)},
$ia1:1,
$iH:1}
J.dR.prototype={
D(a,b){return null==b},
j(a){return"null"},
gv(a){return 0},
$ia1:1,
$iF:1}
J.ai.prototype={$iv:1}
J.cn.prototype={
gv(a){return 0},
ga4(a){return B.bP},
j(a){return String(a)}}
J.iY.prototype={}
J.de.prototype={}
J.b2.prototype={
j(a){var s=a[$.zk()]
if(s==null)s=a[$.dD()]
if(s==null)return this.kN(a)
return"JavaScript function for "+J.be(s)}}
J.aQ.prototype={
gv(a){return 0},
j(a){return String(a)}}
J.dT.prototype={
gv(a){return 0},
j(a){return String(a)}}
J.w.prototype={
ea(a,b){return new A.ag(a,A.a5(a).h("@<1>").I(b).h("ag<1,2>"))},
q(a,b){a.$flags&1&&A.C(a,29)
a.push(b)},
ex(a,b){var s
a.$flags&1&&A.C(a,"removeAt",1)
s=a.length
if(b>=s)throw A.a(A.of(b,null))
return a.splice(b,1)[0]},
ol(a,b,c){var s
a.$flags&1&&A.C(a,"insert",2)
s=a.length
if(b>s)throw A.a(A.of(b,null))
a.splice(b,0,c)},
h0(a,b,c){var s,r
a.$flags&1&&A.C(a,"insertAll",2)
A.xm(b,0,a.length,"index")
if(!t.O.b(c))c=J.A3(c)
s=J.aN(c)
a.length=a.length+s
r=b+s
this.X(a,r,a.length,a,b)
this.af(a,b,r,c)},
jO(a){a.$flags&1&&A.C(a,"removeLast",1)
if(a.length===0)throw A.a(A.kS(a,-1))
return a.pop()},
H(a,b){var s
a.$flags&1&&A.C(a,"remove",1)
for(s=0;s<a.length;++s)if(J.A(a[s],b)){a.splice(s,1)
return!0}return!1},
mm(a,b,c){var s,r,q,p=[],o=a.length
for(s=0;s<o;++s){r=a[s]
if(!b.$1(r))p.push(r)
if(a.length!==o)throw A.a(A.ao(a))}q=p.length
if(q===o)return
this.sk(a,q)
for(s=0;s<p.length;++s)a[s]=p[s]},
aa(a,b){var s
a.$flags&1&&A.C(a,"addAll",2)
if(Array.isArray(b)){this.lf(a,b)
return}for(s=J.Z(b);s.m();)a.push(s.gp())},
lf(a,b){var s,r=b.length
if(r===0)return
if(a===b)throw A.a(A.ao(a))
for(s=0;s<r;++s)a.push(b[s])},
au(a){a.$flags&1&&A.C(a,"clear","clear")
a.length=0},
b9(a,b,c){return new A.a8(a,b,A.a5(a).h("@<1>").I(c).h("a8<1,2>"))},
bp(a,b){var s,r=A.b7(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)r[s]=A.q(a[s])
return r.join(b)},
bO(a,b){return A.bK(a,0,A.bd(b,"count",t.S),A.a5(a).c)},
aU(a,b){return A.bK(a,b,null,A.a5(a).c)},
jm(a,b){var s,r,q=a.length
for(s=0;s<q;++s){r=a[s]
if(b.$1(r))return r
if(a.length!==q)throw A.a(A.ao(a))}throw A.a(A.bW())},
V(a,b){return a[b]},
gai(a){if(a.length>0)return a[0]
throw A.a(A.bW())},
gaQ(a){var s=a.length
if(s>0)return a[s-1]
throw A.a(A.bW())},
X(a,b,c,d,e){var s,r,q,p,o
a.$flags&2&&A.C(a,5)
A.aJ(b,c,a.length)
s=c-b
if(s===0)return
A.aI(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.l1(d,e).cb(0,!1)
q=0}p=J.ab(r)
if(q+s>p.gk(r))throw A.a(A.wY())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.i(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.i(r,q+o)},
af(a,b,c,d){return this.X(a,b,c,d,0)},
cP(a,b){var s,r,q,p,o
a.$flags&2&&A.C(a,"sort")
s=a.length
if(s<2)return
if(b==null)b=J.De()
if(s===2){r=a[0]
q=a[1]
if(b.$2(r,q)>0){a[0]=q
a[1]=r}return}p=0
if(A.a5(a).c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.cI(b,2))
if(p>0)this.mn(a,p)},
kF(a){return this.cP(a,null)},
mn(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
cw(a,b){var s,r=a.length
if(0>=r)return-1
for(s=0;s<r;++s)if(J.A(a[s],b))return s
return-1},
cA(a,b){var s,r=a.length,q=r-1
if(q<0)return-1
q<r
for(s=q;s>=0;--s)if(J.A(a[s],b))return s
return-1},
U(a,b){var s
for(s=0;s<a.length;++s)if(J.A(a[s],b))return!0
return!1},
gF(a){return a.length===0},
gaP(a){return a.length!==0},
j(a){return A.nH(a,"[","]")},
cb(a,b){var s=A.u(a.slice(0),A.a5(a))
return s},
jS(a){return this.cb(a,!0)},
gA(a){return new J.dF(a,a.length,A.a5(a).h("dF<1>"))},
gv(a){return A.e0(a)},
gk(a){return a.length},
sk(a,b){a.$flags&1&&A.C(a,"set length","change the length of")
if(b<0)throw A.a(A.ac(b,0,null,"newLength",null))
if(b>a.length)A.a5(a).c.a(null)
a.length=b},
i(a,b){if(!(b>=0&&b<a.length))throw A.a(A.kS(a,b))
return a[b]},
l(a,b,c){a.$flags&2&&A.C(a)
if(!(b>=0&&b<a.length))throw A.a(A.kS(a,b))
a[b]=c},
oj(a,b){var s
if(0>=a.length)return-1
for(s=0;s<a.length;++s)if(b.$1(a[s]))return s
return-1},
ga4(a){return A.bm(A.a5(a))},
$iaF:1,
$ix:1,
$in:1,
$it:1}
J.iy.prototype={
p6(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.j_(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.nI.prototype={}
J.dF.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.a(A.a6(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0}}
J.dS.prototype={
a_(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gh3(b)
if(this.gh3(a)===s)return 0
if(this.gh3(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gh3(a){return a===0?1/a<0:a<0},
n6(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.a(A.P(""+a+".ceil()"))},
n7(a,b,c){if(B.b.a_(b,c)>0)throw A.a(A.dz(b))
if(this.a_(a,b)<0)return b
if(this.a_(a,c)>0)return c
return a},
p0(a,b){var s,r,q,p
if(b<2||b>36)throw A.a(A.ac(b,2,36,"radix",null))
s=a.toString(b)
if(s.charCodeAt(s.length-1)!==41)return s
r=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(r==null)A.r(A.P("Unexpected toString result: "+s))
s=r[1]
q=+r[3]
p=r[2]
if(p!=null){s+=p
q-=p.length}return s+B.a.aL("0",q)},
j(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gv(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
dF(a,b){return a+b},
aT(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
hB(a,b){if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.iL(a,b)},
Y(a,b){return(a|0)===a?a/b|0:this.iL(a,b)},
iL(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.a(A.P("Result of truncating division is "+A.q(s)+": "+A.q(a)+" ~/ "+b))},
cN(a,b){if(b<0)throw A.a(A.dz(b))
return b>31?0:a<<b>>>0},
cO(a,b){var s
if(b<0)throw A.a(A.dz(b))
if(a>0)s=this.fw(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
a2(a,b){var s
if(a>0)s=this.fw(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
mB(a,b){if(0>b)throw A.a(A.dz(b))
return this.fw(a,b)},
fw(a,b){return b>31?0:a>>>b},
kx(a,b){return a>b},
ga4(a){return A.bm(t.q)},
$ia7:1,
$iY:1}
J.fl.prototype={
gj4(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.Y(q,4294967296)
s+=32}return s-Math.clz32(q)},
ga4(a){return A.bm(t.S)},
$ia1:1,
$ic:1}
J.iA.prototype={
ga4(a){return A.bm(t.i)},
$ia1:1}
J.cm.prototype={
fH(a,b,c){var s=b.length
if(c>s)throw A.a(A.ac(c,0,s,null,null))
return new A.kt(b,a,c)},
e7(a,b){return this.fH(a,b,0)},
cC(a,b,c){var s,r,q=null
if(c<0||c>b.length)throw A.a(A.ac(c,0,b.length,q,q))
s=a.length
if(c+s>b.length)return q
for(r=0;r<s;++r)if(b.charCodeAt(c+r)!==a.charCodeAt(r))return q
return new A.fK(c,a)},
bF(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.a0(a,r-s)},
dL(a,b){var s=A.u(a.split(b),t.s)
return s},
c9(a,b,c,d){var s=A.aJ(b,c,a.length)
return A.zc(a,b,s,d)},
R(a,b,c){var s
if(c<0||c>a.length)throw A.a(A.ac(c,0,a.length,null,null))
s=c+b.length
if(s>a.length)return!1
return b===a.substring(c,s)},
K(a,b){return this.R(a,b,0)},
t(a,b,c){return a.substring(b,A.aJ(b,c,a.length))},
a0(a,b){return this.t(a,b,null)},
aL(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.a(B.aZ)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
oK(a,b,c){var s=b-a.length
if(s<=0)return a
return this.aL(c,s)+a},
oL(a,b){var s=b-a.length
if(s<=0)return a
return a+this.aL(" ",s)},
bn(a,b,c){var s
if(c<0||c>a.length)throw A.a(A.ac(c,0,a.length,null,null))
s=a.indexOf(b,c)
return s},
cw(a,b){return this.bn(a,b,0)},
em(a,b,c){var s,r
if(c==null)c=a.length
else if(c<0||c>a.length)throw A.a(A.ac(c,0,a.length,null,null))
s=b.length
r=a.length
if(c+s>r)c=r-s
return a.lastIndexOf(b,c)},
cA(a,b){return this.em(a,b,null)},
U(a,b){return A.EZ(a,b,0)},
a_(a,b){var s
if(a===b)s=0
else s=a<b?-1:1
return s},
j(a){return a},
gv(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
ga4(a){return A.bm(t.N)},
gk(a){return a.length},
i(a,b){if(!(b>=0&&b<a.length))throw A.a(A.kS(a,b))
return a[b]},
$iaF:1,
$ia1:1,
$ia7:1,
$ij:1}
A.cS.prototype={
gaw(){return this.a.gaw()},
B(a,b,c,d){var s=this.a.bq(null,b,c),r=new A.dG(s,$.m,this.$ti.h("dG<1,2>"))
s.bt(r.glc())
r.bt(a)
r.ds(d)
return r},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.dG.prototype={
u(){return this.a.u()},
bt(a){this.c=a==null?null:this.b.bM(a,t.z,this.$ti.y[1])},
ds(a){var s=this
s.a.ds(a)
if(a==null)s.d=null
else if(t.r.b(a))s.d=s.b.cE(a,t.z,t.K,t.l)
else if(t.i6.b(a))s.d=s.b.bM(a,t.z,t.K)
else throw A.a(A.J(u.y,null))},
ld(a){var s,r,q,p,o,n,m=this,l=m.c
if(l==null)return
s=null
try{s=m.$ti.y[1].a(a)}catch(o){r=A.E(o)
q=A.I(o)
p=m.d
if(p==null)m.b.c7(r,q)
else{l=t.K
n=m.b
if(t.r.b(p))n.hg(p,r,q,l,t.l)
else n.ca(t.i6.a(p),r,l)}return}m.b.ca(l,s,m.$ti.y[1])},
aJ(a){this.a.aJ(a)},
aj(){return this.aJ(null)},
am(){this.a.am()},
$iae:1}
A.cz.prototype={
gA(a){return new A.i7(J.Z(this.gb6()),A.p(this).h("i7<1,2>"))},
gk(a){return J.aN(this.gb6())},
gF(a){return J.l0(this.gb6())},
gaP(a){return J.zY(this.gb6())},
aU(a,b){var s=A.p(this)
return A.i6(J.l1(this.gb6(),b),s.c,s.y[1])},
bO(a,b){var s=A.p(this)
return A.i6(J.wB(this.gb6(),b),s.c,s.y[1])},
V(a,b){return A.p(this).y[1].a(J.l_(this.gb6(),b))},
U(a,b){return J.wy(this.gb6(),b)},
j(a){return J.be(this.gb6())}}
A.i7.prototype={
m(){return this.a.m()},
gp(){return this.$ti.y[1].a(this.a.gp())}}
A.cQ.prototype={
gb6(){return this.a}}
A.h9.prototype={$ix:1}
A.h3.prototype={
i(a,b){return this.$ti.y[1].a(J.eV(this.a,b))},
l(a,b,c){J.kZ(this.a,b,this.$ti.c.a(c))},
sk(a,b){J.A0(this.a,b)},
q(a,b){J.hP(this.a,this.$ti.c.a(b))},
cP(a,b){var s=b==null?null:new A.qY(this,b)
J.wA(this.a,s)},
X(a,b,c,d,e){var s=this.$ti
J.A1(this.a,b,c,A.i6(d,s.y[1],s.c),e)},
af(a,b,c,d){return this.X(0,b,c,d,0)},
$ix:1,
$it:1}
A.qY.prototype={
$2(a,b){var s=this.a.$ti.y[1]
return this.b.$2(s.a(a),s.a(b))},
$S(){return this.a.$ti.h("c(1,1)")}}
A.ag.prototype={
ea(a,b){return new A.ag(this.a,this.$ti.h("@<1>").I(b).h("ag<1,2>"))},
gb6(){return this.a}}
A.cR.prototype={
bk(a,b,c){return new A.cR(this.a,this.$ti.h("@<1,2>").I(b).I(c).h("cR<1,2,3,4>"))},
E(a){return this.a.E(a)},
i(a,b){return this.$ti.h("4?").a(this.a.i(0,b))},
l(a,b,c){var s=this.$ti
this.a.l(0,s.c.a(b),s.y[1].a(c))},
ad(a,b){this.a.ad(0,new A.lF(this,b))},
ga3(){var s=this.$ti
return A.i6(this.a.ga3(),s.c,s.y[2])},
gk(a){var s=this.a
return s.gk(s)},
gF(a){var s=this.a
return s.gF(s)},
gbl(){var s=this.a.gbl()
return s.b9(s,new A.lE(this),this.$ti.h("M<3,4>"))}}
A.lF.prototype={
$2(a,b){var s=this.a.$ti
this.b.$2(s.y[2].a(a),s.y[3].a(b))},
$S(){return this.a.$ti.h("~(1,2)")}}
A.lE.prototype={
$1(a){var s=this.a.$ti
return new A.M(s.y[2].a(a.a),s.y[3].a(a.b),s.h("M<3,4>"))},
$S(){return this.a.$ti.h("M<3,4>(M<1,2>)")}}
A.d_.prototype={
j(a){return"LateInitializationError: "+this.a}}
A.br.prototype={
gk(a){return this.a.length},
i(a,b){return this.a.charCodeAt(b)}}
A.v2.prototype={
$0(){return A.n5(null,t.H)},
$S:3}
A.ox.prototype={}
A.x.prototype={}
A.X.prototype={
gA(a){var s=this
return new A.at(s,s.gk(s),A.p(s).h("at<X.E>"))},
gF(a){return this.gk(this)===0},
gai(a){if(this.gk(this)===0)throw A.a(A.bW())
return this.V(0,0)},
U(a,b){var s,r=this,q=r.gk(r)
for(s=0;s<q;++s){if(J.A(r.V(0,s),b))return!0
if(q!==r.gk(r))throw A.a(A.ao(r))}return!1},
bp(a,b){var s,r,q,p=this,o=p.gk(p)
if(b.length!==0){if(o===0)return""
s=A.q(p.V(0,0))
if(o!==p.gk(p))throw A.a(A.ao(p))
for(r=s,q=1;q<o;++q){r=r+b+A.q(p.V(0,q))
if(o!==p.gk(p))throw A.a(A.ao(p))}return r.charCodeAt(0)==0?r:r}else{for(q=0,r="";q<o;++q){r+=A.q(p.V(0,q))
if(o!==p.gk(p))throw A.a(A.ao(p))}return r.charCodeAt(0)==0?r:r}},
oo(a){return this.bp(0,"")},
b9(a,b,c){return new A.a8(this,b,A.p(this).h("@<X.E>").I(c).h("a8<1,2>"))},
oR(a,b){var s,r,q=this,p=q.gk(q)
if(p===0)throw A.a(A.bW())
s=q.V(0,0)
for(r=1;r<p;++r){s=b.$2(s,q.V(0,r))
if(p!==q.gk(q))throw A.a(A.ao(q))}return s},
aU(a,b){return A.bK(this,b,null,A.p(this).h("X.E"))},
bO(a,b){return A.bK(this,0,A.bd(b,"count",t.S),A.p(this).h("X.E"))},
dD(a){var s,r=this,q=A.vy(A.p(r).h("X.E"))
for(s=0;s<r.gk(r);++s)q.q(0,r.V(0,s))
return q}}
A.db.prototype={
l1(a,b,c,d){var s,r=this.b
A.aI(r,"start")
s=this.c
if(s!=null){A.aI(s,"end")
if(r>s)throw A.a(A.ac(r,0,s,"start",null))}},
glz(){var s=J.aN(this.a),r=this.c
if(r==null||r>s)return s
return r},
gmD(){var s=J.aN(this.a),r=this.b
if(r>s)return s
return r},
gk(a){var s,r=J.aN(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
V(a,b){var s=this,r=s.gmD()+b
if(b<0||r>=s.glz())throw A.a(A.iu(b,s.gk(0),s,null,"index"))
return J.l_(s.a,r)},
aU(a,b){var s,r,q=this
A.aI(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.cX(q.$ti.h("cX<1>"))
return A.bK(q.a,s,r,q.$ti.c)},
bO(a,b){var s,r,q,p=this
A.aI(b,"count")
s=p.c
r=p.b
if(s==null)return A.bK(p.a,r,B.b.dF(r,b),p.$ti.c)
else{q=B.b.dF(r,b)
if(s<q)return p
return A.bK(p.a,r,q,p.$ti.c)}},
cb(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.ab(n),l=m.gk(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=J.vs(0,p.$ti.c)
return n}r=A.b7(s,m.V(n,o),!1,p.$ti.c)
for(q=1;q<s;++q){r[q]=m.V(n,o+q)
if(m.gk(n)<l)throw A.a(A.ao(p))}return r}}
A.at.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=J.ab(q),o=p.gk(q)
if(r.b!==o)throw A.a(A.ao(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.V(q,s);++r.c
return!0}}
A.bY.prototype={
gA(a){return new A.cp(J.Z(this.a),this.b,A.p(this).h("cp<1,2>"))},
gk(a){return J.aN(this.a)},
gF(a){return J.l0(this.a)},
V(a,b){return this.b.$1(J.l_(this.a,b))}}
A.bU.prototype={$ix:1}
A.cp.prototype={
m(){var s=this,r=s.b
if(r.m()){s.a=s.c.$1(r.gp())
return!0}s.a=null
return!1},
gp(){var s=this.a
return s==null?this.$ti.y[1].a(s):s}}
A.a8.prototype={
gk(a){return J.aN(this.a)},
V(a,b){return this.b.$1(J.l_(this.a,b))}}
A.c7.prototype={
gA(a){return new A.ef(J.Z(this.a),this.b)},
b9(a,b,c){return new A.bY(this,b,this.$ti.h("@<1>").I(c).h("bY<1,2>"))}}
A.ef.prototype={
m(){var s,r
for(s=this.a,r=this.b;s.m();)if(r.$1(s.gp()))return!0
return!1},
gp(){return this.a.gp()}}
A.fc.prototype={
gA(a){return new A.im(J.Z(this.a),this.b,B.a2,this.$ti.h("im<1,2>"))}}
A.im.prototype={
gp(){var s=this.d
return s==null?this.$ti.y[1].a(s):s},
m(){var s,r,q=this,p=q.c
if(p==null)return!1
for(s=q.a,r=q.b;!p.m();){q.d=null
if(s.m()){q.c=null
p=J.Z(r.$1(s.gp()))
q.c=p}else return!1}q.d=q.c.gp()
return!0}}
A.dd.prototype={
gA(a){var s=this.a
return new A.jo(s.gA(s),this.b,A.p(this).h("jo<1>"))}}
A.fa.prototype={
gk(a){var s=this.a,r=s.gk(s)
s=this.b
if(B.b.kx(r,s))return s
return r},
$ix:1}
A.jo.prototype={
m(){if(--this.b>=0)return this.a.m()
this.b=-1
return!1},
gp(){if(this.b<0){this.$ti.c.a(null)
return null}return this.a.gp()}}
A.c1.prototype={
aU(a,b){A.hS(b,"count")
A.aI(b,"count")
return new A.c1(this.a,this.b+b,A.p(this).h("c1<1>"))},
gA(a){var s=this.a
return new A.j9(s.gA(s),this.b)}}
A.dM.prototype={
gk(a){var s=this.a,r=s.gk(s)-this.b
if(r>=0)return r
return 0},
aU(a,b){A.hS(b,"count")
A.aI(b,"count")
return new A.dM(this.a,this.b+b,this.$ti)},
$ix:1}
A.j9.prototype={
m(){var s,r
for(s=this.a,r=0;r<this.b;++r)s.m()
this.b=0
return s.m()},
gp(){return this.a.gp()}}
A.cX.prototype={
gA(a){return B.a2},
gF(a){return!0},
gk(a){return 0},
V(a,b){throw A.a(A.ac(b,0,0,"index",null))},
U(a,b){return!1},
b9(a,b,c){return new A.cX(c.h("cX<0>"))},
aU(a,b){A.aI(b,"count")
return this},
bO(a,b){A.aI(b,"count")
return this},
cb(a,b){var s=J.vs(0,this.$ti.c)
return s}}
A.ii.prototype={
m(){return!1},
gp(){throw A.a(A.bW())}}
A.fX.prototype={
gA(a){return new A.jB(J.Z(this.a),this.$ti.h("jB<1>"))}}
A.jB.prototype={
m(){var s,r
for(s=this.a,r=this.$ti.c;s.m();)if(r.b(s.gp()))return!0
return!1},
gp(){return this.$ti.c.a(this.a.gp())}}
A.fz.prototype={
gi4(){var s,r,q
for(s=this.a,r=A.p(s),s=new A.cp(J.Z(s.a),s.b,r.h("cp<1,2>")),r=r.y[1];s.m();){q=s.a
if(q==null)q=r.a(q)
if(q!=null)return q}return null},
gF(a){return this.gi4()==null},
gaP(a){return this.gi4()!=null},
gA(a){var s=this.a
return new A.iS(new A.cp(J.Z(s.a),s.b,A.p(s).h("cp<1,2>")))}}
A.iS.prototype={
m(){var s,r,q
this.b=null
for(s=this.a,r=s.$ti.y[1];s.m();){q=s.a
if(q==null)q=r.a(q)
if(q!=null){this.b=q
return!0}}return!1},
gp(){var s=this.b
return s==null?A.r(A.bW()):s}}
A.ff.prototype={
sk(a,b){throw A.a(A.P(u.O))},
q(a,b){throw A.a(A.P("Cannot add to a fixed-length list"))}}
A.jr.prototype={
l(a,b,c){throw A.a(A.P("Cannot modify an unmodifiable list"))},
sk(a,b){throw A.a(A.P("Cannot change the length of an unmodifiable list"))},
q(a,b){throw A.a(A.P("Cannot add to an unmodifiable list"))},
cP(a,b){throw A.a(A.P("Cannot modify an unmodifiable list"))},
X(a,b,c,d,e){throw A.a(A.P("Cannot modify an unmodifiable list"))},
af(a,b,c,d){return this.X(0,b,c,d,0)}}
A.eb.prototype={}
A.d8.prototype={
gk(a){return J.aN(this.a)},
V(a,b){var s=this.a,r=J.ab(s)
return r.V(s,r.gk(s)-1-b)}}
A.fL.prototype={
gv(a){var s=this._hashCode
if(s!=null)return s
s=664597*B.a.gv(this.a)&536870911
this._hashCode=s
return s},
j(a){return'Symbol("'+this.a+'")'},
D(a,b){if(b==null)return!1
return b instanceof A.fL&&this.a===b.a}}
A.hG.prototype={}
A.ho.prototype={$r:"+immediateRestart(1)",$s:1}
A.Q.prototype={$r:"+(1,2)",$s:2}
A.hp.prototype={$r:"+basicSupport,supportsReadWriteUnsafe(1,2)",$s:3}
A.hq.prototype={$r:"+controller,sync(1,2)",$s:4}
A.kc.prototype={$r:"+downloaded,total(1,2)",$s:5}
A.ez.prototype={$r:"+file,outFlags(1,2)",$s:6}
A.kd.prototype={$r:"+name,parameters(1,2)",$s:7}
A.ke.prototype={$r:"+result,resultCode(1,2)",$s:8}
A.hr.prototype={$r:"+(1,2,3)",$s:9}
A.kf.prototype={$r:"+autocommit,lastInsertRowid,result(1,2,3)",$s:10}
A.kg.prototype={$r:"+connectName,connectPort,lockName(1,2,3)",$s:11}
A.kh.prototype={$r:"+hasSynced,lastSyncedAt,priority(1,2,3)",$s:12}
A.ki.prototype={$r:"+atLast,priority,sinceLast,targetCount(1,2,3,4)",$s:13}
A.f2.prototype={
bk(a,b,c){var s=A.p(this)
return A.x6(this,s.c,s.y[1],b,c)},
gF(a){return this.gk(this)===0},
j(a){return A.nS(this)},
l(a,b,c){A.Ak()},
gbl(){return new A.eD(this.nK(),A.p(this).h("eD<M<1,2>>"))},
nK(){var s=this
return function(){var r=0,q=1,p=[],o,n,m
return function $async$gbl(a,b,c){if(b===1){p.push(c)
r=q}for(;;)switch(r){case 0:o=s.ga3(),o=o.gA(o),n=A.p(s).h("M<1,2>")
case 2:if(!o.m()){r=3
break}m=o.gp()
r=4
return a.b=new A.M(m,s.i(0,m),n),1
case 4:r=2
break
case 3:return 0
case 1:return a.c=p.at(-1),3}}}},
cB(a,b,c,d){var s=A.T(c,d)
this.ad(0,new A.m_(this,b,s))
return s},
$ia_:1}
A.m_.prototype={
$2(a,b){var s=this.b.$2(a,b)
this.c.l(0,s.a,s.b)},
$S(){return A.p(this.a).h("~(1,2)")}}
A.b0.prototype={
gk(a){return this.b.length},
gih(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
E(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
i(a,b){if(!this.E(b))return null
return this.b[this.a[b]]},
ad(a,b){var s,r,q=this.gih(),p=this.b
for(s=q.length,r=0;r<s;++r)b.$2(q[r],p[r])},
ga3(){return new A.hf(this.gih(),this.$ti.h("hf<1>"))}}
A.hf.prototype={
gk(a){return this.a.length},
gF(a){return 0===this.a.length},
gaP(a){return 0!==this.a.length},
gA(a){var s=this.a
return new A.et(s,s.length,this.$ti.h("et<1>"))}}
A.et.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0}}
A.f3.prototype={
q(a,b){A.Al()}}
A.f4.prototype={
gk(a){return this.b},
gF(a){return this.b===0},
gaP(a){return this.b!==0},
gA(a){var s,r=this,q=r.$keys
if(q==null){q=Object.keys(r.a)
r.$keys=q}s=q
return new A.et(s,s.length,r.$ti.h("et<1>"))},
U(a,b){if(typeof b!="string")return!1
if("__proto__"===b)return!1
return this.a.hasOwnProperty(b)},
dD(a){return A.AS(this,this.$ti.c)}}
A.nB.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.fk&&this.a.D(0,b.a)&&A.wl(this)===A.wl(b)},
gv(a){return A.c0(this.a,A.wl(this),B.e,B.e,B.e,B.e)},
j(a){var s=B.c.bp([A.bm(this.$ti.c)],", ")
return this.a.j(0)+" with "+("<"+s+">")}}
A.fk.prototype={
$1(a){return this.a.$1$1(a,this.$ti.y[0])},
$2(a,b){return this.a.$1$2(a,b,this.$ti.y[0])},
$4(a,b,c,d){return this.a.$1$4(a,b,c,d,this.$ti.y[0])},
$S(){return A.EC(A.kR(this.a),this.$ti)}}
A.fB.prototype={}
A.pB.prototype={
ba(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.fA.prototype={
j(a){return"Null check operator used on a null value"}}
A.iB.prototype={
j(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.jq.prototype={
j(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.iU.prototype={
j(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"},
$iO:1}
A.fb.prototype={}
A.hu.prototype={
j(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iad:1}
A.cT.prototype={
j(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.zh(r==null?"unknown":r)+"'"},
ga4(a){var s=A.kR(this)
return A.bm(s==null?A.bo(this):s)},
gpV(){return this},
$C:"$1",
$R:1,
$D:null}
A.lL.prototype={$C:"$0",$R:0}
A.lM.prototype={$C:"$2",$R:2}
A.pp.prototype={}
A.oI.prototype={
j(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.zh(s)+"'"}}
A.eX.prototype={
D(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.eX))return!1
return this.$_target===b.$_target&&this.a===b.a},
gv(a){return(A.kT(this.a)^A.e0(this.$_target))>>>0},
j(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.j_(this.a)+"'")}}
A.j6.prototype={
j(a){return"RuntimeError: "+this.a}}
A.b4.prototype={
gk(a){return this.a},
gF(a){return this.a===0},
ga3(){return new A.b5(this,A.p(this).h("b5<1>"))},
gbl(){return new A.aG(this,A.p(this).h("aG<1,2>"))},
E(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.jx(a)},
jx(a){var s=this.d
if(s==null)return!1
return this.cz(this.i9(s,a),a)>=0},
aa(a,b){b.ad(0,new A.nJ(this))},
i(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.jy(b)},
jy(a){var s,r,q=this.d
if(q==null)return null
s=this.i9(q,a)
r=this.cz(s,a)
if(r<0)return null
return s[r].b},
l(a,b,c){var s,r,q=this
if(typeof b=="string"){s=q.b
q.hF(s==null?q.b=q.fp():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.hF(r==null?q.c=q.fp():r,b,c)}else q.jA(b,c)},
jA(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=p.fp()
s=p.dn(a)
r=o[s]
if(r==null)o[s]=[p.fq(a,b)]
else{q=p.cz(r,a)
if(q>=0)r[q].b=b
else r.push(p.fq(a,b))}},
cD(a,b){var s,r,q=this
if(q.E(a)){s=q.i(0,a)
return s==null?A.p(q).y[1].a(s):s}r=b.$0()
q.l(0,a,r)
return r},
H(a,b){var s=this
if(typeof b=="string")return s.iz(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.iz(s.c,b)
else return s.jz(b)},
jz(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.dn(a)
r=n[s]
q=o.cz(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.iQ(p)
if(r.length===0)delete n[s]
return p.b},
au(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.fo()}},
ad(a,b){var s=this,r=s.e,q=s.r
while(r!=null){b.$2(r.a,r.b)
if(q!==s.r)throw A.a(A.ao(s))
r=r.c}},
hF(a,b,c){var s=a[b]
if(s==null)a[b]=this.fq(b,c)
else s.b=c},
iz(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.iQ(s)
delete a[b]
return s.b},
fo(){this.r=this.r+1&1073741823},
fq(a,b){var s,r=this,q=new A.nM(a,b)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.d=s
r.f=s.c=q}++r.a
r.fo()
return q},
iQ(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.fo()},
dn(a){return J.V(a)&1073741823},
i9(a,b){return a[this.dn(b)]},
cz(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.A(a[r].a,b))return r
return-1},
j(a){return A.nS(this)},
fp(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s}}
A.nJ.prototype={
$2(a,b){this.a.l(0,a,b)},
$S(){return A.p(this.a).h("~(1,2)")}}
A.nM.prototype={}
A.b5.prototype={
gk(a){return this.a.a},
gF(a){return this.a.a===0},
gA(a){var s=this.a
return new A.d0(s,s.r,s.e)},
U(a,b){return this.a.E(b)}}
A.d0.prototype={
gp(){return this.d},
m(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.a(A.ao(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}}}
A.bX.prototype={
gk(a){return this.a.a},
gF(a){return this.a.a===0},
gA(a){var s=this.a
return new A.b6(s,s.r,s.e)}}
A.b6.prototype={
gp(){return this.d},
m(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.a(A.ao(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}}}
A.aG.prototype={
gk(a){return this.a.a},
gF(a){return this.a.a===0},
gA(a){var s=this.a
return new A.iI(s,s.r,s.e,this.$ti.h("iI<1,2>"))}}
A.iI.prototype={
gp(){var s=this.d
s.toString
return s},
m(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.a(A.ao(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.M(s.a,s.b,r.$ti.h("M<1,2>"))
r.c=s.c
return!0}}}
A.fn.prototype={
dn(a){return A.kT(a)&1073741823},
cz(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;++r){q=a[r].a
if(q==null?b==null:q===b)return r}return-1}}
A.uN.prototype={
$1(a){return this.a(a)},
$S:50}
A.uO.prototype={
$2(a,b){return this.a(a,b)},
$S:87}
A.uP.prototype={
$1(a){return this.a(a)},
$S:120}
A.hn.prototype={
ga4(a){return A.bm(this.ia())},
ia(){return A.Ep(this.$r,this.cW())},
j(a){return this.iP(!1)},
iP(a){var s,r,q,p,o,n=this.lD(),m=this.cW(),l=(a?"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
o=m[q]
l=a?l+A.xk(o):l+A.q(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
lD(){var s,r=this.$s
while($.tc.length<=r)$.tc.push(null)
s=$.tc[r]
if(s==null){s=this.lq()
$.tc[r]=s}return s},
lq(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=A.u(new Array(l),t.hf)
for(s=0;s<l;++s)k[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
k[q]=r[s]}}return A.nP(k,t.K)}}
A.k9.prototype={
cW(){return[this.a,this.b]},
D(a,b){if(b==null)return!1
return b instanceof A.k9&&this.$s===b.$s&&J.A(this.a,b.a)&&J.A(this.b,b.b)},
gv(a){return A.c0(this.$s,this.a,this.b,B.e,B.e,B.e)}}
A.k8.prototype={
cW(){return[this.a]},
D(a,b){if(b==null)return!1
return b instanceof A.k8&&this.$s===b.$s&&J.A(this.a,b.a)},
gv(a){return A.c0(this.$s,this.a,B.e,B.e,B.e,B.e)}}
A.ka.prototype={
cW(){return[this.a,this.b,this.c]},
D(a,b){var s=this
if(b==null)return!1
return b instanceof A.ka&&s.$s===b.$s&&J.A(s.a,b.a)&&J.A(s.b,b.b)&&J.A(s.c,b.c)},
gv(a){var s=this
return A.c0(s.$s,s.a,s.b,s.c,B.e,B.e)}}
A.kb.prototype={
cW(){return this.a},
D(a,b){if(b==null)return!1
return b instanceof A.kb&&this.$s===b.$s&&A.Cq(this.a,b.a)},
gv(a){return A.c0(this.$s,A.B1(this.a),B.e,B.e,B.e,B.e)}}
A.fm.prototype={
j(a){return"RegExp/"+this.a+"/"+this.b.flags},
glZ(){var s=this,r=s.c
if(r!=null)return r
r=s.b
return s.c=A.vu(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,"g")},
glY(){var s=this,r=s.d
if(r!=null)return r
r=s.b
return s.d=A.vu(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,"y")},
jl(a){var s=this.b.exec(a)
if(s==null)return null
return new A.ex(s)},
fH(a,b,c){var s=b.length
if(c>s)throw A.a(A.ac(c,0,s,null,null))
return new A.jF(this,b,c)},
e7(a,b){return this.fH(0,b,0)},
lC(a,b){var s,r=this.glZ()
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.ex(s)},
lB(a,b){var s,r=this.glY()
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.ex(s)},
cC(a,b,c){if(c<0||c>b.length)throw A.a(A.ac(c,0,b.length,null,null))
return this.lB(b,c)}}
A.ex.prototype={
gC(){var s=this.b
return s.index+s[0].length},
i(a,b){return this.b[b]},
$id2:1,
$ij1:1}
A.jF.prototype={
gA(a){return new A.jG(this.a,this.b,this.c)}}
A.jG.prototype={
gp(){var s=this.d
return s==null?t.lu.a(s):s},
m(){var s,r,q,p,o,n,m=this,l=m.b
if(l==null)return!1
s=m.c
r=l.length
if(s<=r){q=m.a
p=q.lC(l,s)
if(p!=null){m.d=p
o=p.gC()
if(p.b.index===o){s=!1
if(q.b.unicode){q=m.c
n=q+1
if(n<r){r=l.charCodeAt(q)
if(r>=55296&&r<=56319){s=l.charCodeAt(n)
s=s>=56320&&s<=57343}}}o=(s?o+1:o)+1}m.c=o
return!0}}m.b=m.d=null
return!1}}
A.fK.prototype={
gC(){return this.a+this.c.length},
i(a,b){if(b!==0)throw A.a(A.of(b,null))
return this.c},
$id2:1}
A.kt.prototype={
gA(a){return new A.tv(this.a,this.b,this.c)}}
A.tv.prototype={
m(){var s,r,q=this,p=q.c,o=q.b,n=o.length,m=q.a,l=m.length
if(p+n>l){q.d=null
return!1}s=m.indexOf(o,p)
if(s<0){q.c=l+1
q.d=null
return!1}r=s+n
q.d=new A.fK(s,o)
q.c=r===q.c?r+1:r
return!0},
gp(){var s=this.d
s.toString
return s}}
A.jP.prototype={
dW(){var s=this.b
if(s===this)throw A.a(new A.d_("Local '"+this.a+"' has not been initialized."))
return s},
aV(){var s=this.b
if(s===this)throw A.a(A.x2(this.a))
return s}}
A.dX.prototype={
gjB(a){return a.byteLength},
ga4(a){return B.bI},
e8(a,b,c){A.kL(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
j0(a){return this.e8(a,0,null)},
$ia1:1,
$icO:1}
A.bF.prototype={$ibF:1}
A.fw.prototype={
gar(a){if(((a.$flags|0)&2)!==0)return new A.kB(a.buffer)
else return a.buffer},
lQ(a,b,c,d){var s=A.ac(b,0,c,d,null)
throw A.a(s)},
hK(a,b,c,d){if(b>>>0!==b||b>c)this.lQ(a,b,c,d)}}
A.kB.prototype={
gjB(a){return this.a.byteLength},
e8(a,b,c){var s=A.aV(this.a,b,c)
s.$flags=3
return s},
j0(a){return this.e8(0,0,null)},
$icO:1}
A.fv.prototype={
ga4(a){return B.bJ},
$ia1:1,
$ivk:1}
A.dY.prototype={
gk(a){return a.length},
iH(a,b,c,d,e){var s,r,q=a.length
this.hK(a,b,q,"start")
this.hK(a,c,q,"end")
if(b>c)throw A.a(A.ac(b,0,c,null,null))
s=c-b
if(e<0)throw A.a(A.J(e,null))
r=d.length
if(r-e<s)throw A.a(A.z("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iaF:1,
$ib3:1}
A.cq.prototype={
i(a,b){A.cg(b,a,a.length)
return a[b]},
l(a,b,c){a.$flags&2&&A.C(a)
A.cg(b,a,a.length)
a[b]=c},
X(a,b,c,d,e){a.$flags&2&&A.C(a,5)
if(t.dQ.b(d)){this.iH(a,b,c,d,e)
return}this.hz(a,b,c,d,e)},
af(a,b,c,d){return this.X(a,b,c,d,0)},
$ix:1,
$in:1,
$it:1}
A.b8.prototype={
l(a,b,c){a.$flags&2&&A.C(a)
A.cg(b,a,a.length)
a[b]=c},
X(a,b,c,d,e){a.$flags&2&&A.C(a,5)
if(t.aj.b(d)){this.iH(a,b,c,d,e)
return}this.hz(a,b,c,d,e)},
af(a,b,c,d){return this.X(a,b,c,d,0)},
$ix:1,
$in:1,
$it:1}
A.iL.prototype={
ga4(a){return B.bK},
$ia1:1,
$imY:1}
A.iM.prototype={
ga4(a){return B.bL},
$ia1:1,
$imZ:1}
A.iN.prototype={
ga4(a){return B.bM},
i(a,b){A.cg(b,a,a.length)
return a[b]},
$ia1:1,
$inC:1}
A.iO.prototype={
ga4(a){return B.bN},
i(a,b){A.cg(b,a,a.length)
return a[b]},
$ia1:1,
$inD:1}
A.iP.prototype={
ga4(a){return B.bO},
i(a,b){A.cg(b,a,a.length)
return a[b]},
$ia1:1,
$inE:1}
A.iQ.prototype={
ga4(a){return B.bR},
i(a,b){A.cg(b,a,a.length)
return a[b]},
$ia1:1,
$ipD:1}
A.fx.prototype={
ga4(a){return B.bS},
i(a,b){A.cg(b,a,a.length)
return a[b]},
bS(a,b,c){return new Uint32Array(a.subarray(b,A.yq(b,c,a.length)))},
$ia1:1,
$ipE:1}
A.fy.prototype={
ga4(a){return B.bT},
gk(a){return a.length},
i(a,b){A.cg(b,a,a.length)
return a[b]},
$ia1:1,
$ipF:1}
A.d3.prototype={
ga4(a){return B.bU},
gk(a){return a.length},
i(a,b){A.cg(b,a,a.length)
return a[b]},
bS(a,b,c){return new Uint8Array(a.subarray(b,A.yq(b,c,a.length)))},
$ia1:1,
$id3:1,
$ibh:1}
A.hi.prototype={}
A.hj.prototype={}
A.hk.prototype={}
A.hl.prototype={}
A.bt.prototype={
h(a){return A.hB(v.typeUniverse,this,a)},
I(a){return A.y6(v.typeUniverse,this,a)}}
A.jY.prototype={}
A.tC.prototype={
j(a){return A.bc(this.a,null)}}
A.jU.prototype={
j(a){return this.a}}
A.hx.prototype={$ic4:1}
A.qF.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:12}
A.qE.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:164}
A.qG.prototype={
$0(){this.a.$0()},
$S:1}
A.qH.prototype={
$0(){this.a.$0()},
$S:1}
A.kx.prototype={
la(a,b){if(self.setTimeout!=null)this.b=self.setTimeout(A.cI(new A.tB(this,b),0),a)
else throw A.a(A.P("`setTimeout()` not found."))},
lb(a,b){if(self.setTimeout!=null)this.b=self.setInterval(A.cI(new A.tA(this,a,Date.now(),b),0),a)
else throw A.a(A.P("Periodic timer."))},
u(){if(self.setTimeout!=null){var s=this.b
if(s==null)return
if(this.a)self.clearTimeout(s)
else self.clearInterval(s)
this.b=null}else throw A.a(A.P("Canceling a timer."))}}
A.tB.prototype={
$0(){var s=this.a
s.b=null
s.c=1
this.b.$0()},
$S:0}
A.tA.prototype={
$0(){var s,r=this,q=r.a,p=q.c+1,o=r.b
if(o>0){s=Date.now()-r.c
if(s>(p+1)*o)p=B.b.hB(s,o)}q.c=p
r.d.$1(q)},
$S:1}
A.h0.prototype={
T(a){var s,r=this
if(a==null)a=r.$ti.c.a(a)
if(!r.b)r.a.aE(a)
else{s=r.a
if(r.$ti.h("o<1>").b(a))s.hJ(a)
else s.bV(a)}},
L(){return this.T(null)},
b7(a,b){var s
if(b==null)b=A.cN(a)
s=this.a
if(this.b)s.ac(new A.a2(a,b))
else s.S(new A.a2(a,b))},
ab(a){return this.b7(a,null)},
$icW:1}
A.u1.prototype={
$1(a){return this.a.$2(0,a)},
$S:13}
A.u2.prototype={
$2(a,b){this.a.$2(1,new A.fb(a,b))},
$S:95}
A.uy.prototype={
$2(a,b){this.a(a,b)},
$S:99}
A.u_.prototype={
$0(){var s,r=this.a,q=r.a
q===$&&A.L()
s=q.b
if((s&1)!==0?(q.ga6().e&4)!==0:(s&2)===0){r.b=!0
return}r=r.c!=null?2:0
this.b.$2(r,null)},
$S:0}
A.u0.prototype={
$1(a){var s=this.a.c!=null?2:0
this.b.$2(s,null)},
$S:12}
A.jI.prototype={
l5(a,b){var s=new A.qJ(a)
this.a=A.bI(new A.qL(this,a),new A.qM(s),null,new A.qN(this,s),!1,b)}}
A.qJ.prototype={
$0(){A.eT(new A.qK(this.a))},
$S:1}
A.qK.prototype={
$0(){this.a.$2(0,null)},
$S:0}
A.qM.prototype={
$0(){this.a.$0()},
$S:0}
A.qN.prototype={
$0(){var s=this.a
if(s.b){s.b=!1
this.b.$0()}},
$S:0}
A.qL.prototype={
$0(){var s=this.a,r=s.a
r===$&&A.L()
if((r.b&4)===0){s.c=new A.l($.m,t._)
if(s.b){s.b=!1
A.eT(new A.qI(this.b))}return s.c}},
$S:110}
A.qI.prototype={
$0(){this.a.$2(2,null)},
$S:0}
A.he.prototype={
j(a){return"IterationMarker("+this.b+", "+A.q(this.a)+")"}}
A.kv.prototype={
gp(){return this.b},
mu(a,b){var s,r,q
a=a
b=b
s=this.a
for(;;)try{r=s(this,a,b)
return r}catch(q){b=q
a=1}},
m(){var s,r,q,p,o=this,n=null,m=0
for(;;){s=o.d
if(s!=null)try{if(s.m()){o.b=s.gp()
return!0}else o.d=null}catch(r){n=r
m=1
o.d=null}q=o.mu(m,n)
if(1===q)return!0
if(0===q){o.b=null
p=o.e
if(p==null||p.length===0){o.a=A.y0
return!1}o.a=p.pop()
m=0
n=null
continue}if(2===q){m=0
n=null
continue}if(3===q){n=o.c
o.c=null
p=o.e
if(p==null||p.length===0){o.b=null
o.a=A.y0
throw n
return!1}o.a=p.pop()
m=1
continue}throw A.a(A.z("sync*"))}return!1},
pY(a){var s,r,q=this
if(a instanceof A.eD){s=a.a()
r=q.e
if(r==null)r=q.e=[]
r.push(q.a)
q.a=s
return 2}else{q.d=J.Z(a)
return 2}}}
A.eD.prototype={
gA(a){return new A.kv(this.a())}}
A.a2.prototype={
j(a){return A.q(this.a)},
$iW:1,
gbA(){return this.b}}
A.aq.prototype={
gaw(){return!0}}
A.dk.prototype={
b2(){},
b3(){}}
A.c9.prototype={
sjF(a){throw A.a(A.P(u.t))},
sjG(a){throw A.a(A.P(u.t))},
gbB(){return new A.aq(this,A.p(this).h("aq<1>"))},
gal(){return this.c<4},
dQ(){var s=this.r
return s==null?this.r=new A.l($.m,t.D):s},
iA(a){var s=a.CW,r=a.ch
if(s==null)this.d=r
else s.ch=r
if(r==null)this.e=s
else r.CW=s
a.CW=a
a.ch=a},
fz(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=this
if((j.c&4)!==0)return A.xQ(c,A.p(j).c)
s=A.p(j)
r=$.m
q=d?1:0
p=b!=null?32:0
o=A.jL(r,a,s.c)
n=A.jM(r,b)
m=c==null?A.uz():c
l=new A.dk(j,o,n,r.b_(m,t.H),r,q|p,s.h("dk<1>"))
l.CW=l
l.ch=l
l.ay=j.c&1
k=j.e
j.e=l
l.ch=null
l.CW=k
if(k==null)j.d=l
else k.ch=l
if(j.d===l)A.kO(j.a)
return l},
it(a){var s,r=this
A.p(r).h("dk<1>").a(a)
if(a.ch===a)return null
s=a.ay
if((s&2)!==0)a.ay=s|4
else{r.iA(a)
if((r.c&2)===0&&r.d==null)r.eW()}return null},
iu(a){},
iv(a){},
ak(){if((this.c&4)!==0)return new A.aX("Cannot add new events after calling close")
return new A.aX("Cannot add new events while doing an addStream")},
q(a,b){if(!this.gal())throw A.a(this.ak())
this.a1(b)},
ag(a,b){var s
if(!this.gal())throw A.a(this.ak())
s=A.ax(a,b)
this.bi(s.a,s.b)},
n(){var s,r,q=this
if((q.c&4)!==0){s=q.r
s.toString
return s}if(!q.gal())throw A.a(q.ak())
q.c|=4
r=q.dQ()
q.bE()
return r},
e6(a,b){var s,r=this
if(!r.gal())throw A.a(r.ak())
r.c|=8
s=A.BK(r,a,!1)
r.f=s
return s.a},
iZ(a){return this.e6(a,null)},
N(a){this.a1(a)},
a9(a,b){this.bi(a,b)},
Z(){var s=this.f
s.toString
this.f=null
this.c&=4294967287
s.a.aE(null)},
fb(a){var s,r,q,p=this,o=p.c
if((o&2)!==0)throw A.a(A.z(u.c))
s=p.d
if(s==null)return
r=o&1
p.c=o^3
while(s!=null){o=s.ay
if((o&1)===r){s.ay=o|2
a.$1(s)
o=s.ay^=1
q=s.ch
if((o&4)!==0)p.iA(s)
s.ay&=4294967293
s=q}else s=s.ch}p.c&=4294967293
if(p.d==null)p.eW()},
eW(){if((this.c&4)!==0){var s=this.r
if((s.a&30)===0)s.aE(null)}A.kO(this.b)},
$iaj:1,
$ibH:1,
sjE(a){return this.a=a},
sjD(a){return this.b=a}}
A.du.prototype={
gal(){return A.c9.prototype.gal.call(this)&&(this.c&2)===0},
ak(){if((this.c&2)!==0)return new A.aX(u.c)
return this.kS()},
a1(a){var s=this,r=s.d
if(r==null)return
if(r===s.e){s.c|=2
r.N(a)
s.c&=4294967293
if(s.d==null)s.eW()
return}s.fb(new A.tx(s,a))},
bi(a,b){if(this.d==null)return
this.fb(new A.tz(this,a,b))},
bE(){var s=this
if(s.d!=null)s.fb(new A.ty(s))
else s.r.aE(null)}}
A.tx.prototype={
$1(a){a.N(this.b)},
$S(){return this.a.$ti.h("~(aw<1>)")}}
A.tz.prototype={
$1(a){a.a9(this.b,this.c)},
$S(){return this.a.$ti.h("~(aw<1>)")}}
A.ty.prototype={
$1(a){a.Z()},
$S(){return this.a.$ti.h("~(aw<1>)")}}
A.h1.prototype={
a1(a){var s
for(s=this.d;s!=null;s=s.ch)s.bd(new A.bx(a))},
bi(a,b){var s
for(s=this.d;s!=null;s=s.ch)s.bd(new A.en(a,b))},
bE(){var s=this.d
if(s!=null)for(;s!=null;s=s.ch)s.bd(B.z)
else this.r.aE(null)}}
A.n6.prototype={
$0(){var s,r,q,p,o,n,m=null
try{m=this.a.$0()}catch(q){s=A.E(q)
r=A.I(q)
p=s
o=r
n=A.dx(p,o)
if(n==null)p=new A.a2(p,o)
else p=n
this.b.ac(p)
return}this.b.be(m)},
$S:0}
A.n9.prototype={
$2(a,b){var s=this,r=s.a,q=--r.b
if(r.a!=null){r.a=null
r.d=a
r.c=b
if(q===0||s.c)s.d.ac(new A.a2(a,b))}else if(q===0&&!s.c){q=r.d
q.toString
r=r.c
r.toString
s.d.ac(new A.a2(q,r))}},
$S:6}
A.n8.prototype={
$1(a){var s,r,q,p,o,n,m=this,l=m.a,k=--l.b,j=l.a
if(j!=null){J.kZ(j,m.b,a)
if(J.A(k,0)){l=m.d
s=A.u([],l.h("w<0>"))
for(q=j,p=q.length,o=0;o<q.length;q.length===p||(0,A.a6)(q),++o){r=q[o]
n=r
if(n==null)n=l.a(n)
J.hP(s,n)}m.c.bV(s)}}else if(J.A(k,0)&&!m.f){s=l.d
s.toString
l=l.c
l.toString
m.c.ac(new A.a2(s,l))}},
$S(){return this.d.h("F(0)")}}
A.n_.prototype={
$2(a,b){if(!this.a.b(a))throw A.a(a)
return this.c.$2(a,b)},
$S(){return this.d.h("0/(k,ad)")}}
A.n0.prototype={
$1(a){var s,r,q,p,o,n,m=this
if(a===0){s=A.u([],m.c.h("w<0>"))
for(r=m.b,q=r.length,p=0;p<r.length;r.length===q||(0,A.a6)(r),++p){o=r[p]
n=o.b
if(n==null)o.$ti.c.a(n)
s.push(n)}m.a.T(s)}else{s=A.u([],t.b9)
for(r=m.b,q=r.length,p=0;p<r.length;r.length===q||(0,A.a6)(r),++p)s.push(r[p].c)
q=A.u([],m.c.h("w<0?>"))
for(n=r.length,p=0;p<r.length;r.length===n||(0,A.a6)(r),++p)q.push(r[p].b)
m.a.ab(new A.dZ(B.c.jm(s,A.DY()),a))}},
$S:8}
A.n4.prototype={
$1(a){var s=this,r=s.a,q=s.b
if(a===0)r.T(new A.Q(q.gjU(),s.c.gjU()))
else{q=q.c
r.ab(new A.dZ(q==null?s.c.c:q,a))}},
$S:8}
A.dZ.prototype={
j(a){var s,r,q="ParallelWaitError",p=this.c
if(p==null){p=this.d
s=p<=1
if(s)return q
return"ParallelWaitError("+p+" errors)"}s=this.d
r=s>1
if(r)s="("+s+" errors)"
else s=""
return q+s+": "+A.q(p.a)},
gbA(){var s=this.c
s=s==null?null:s.b
return s==null?A.W.prototype.gbA.call(this):s}}
A.bN.prototype={
gjU(){var s=this.b
if(s==null)this.$ti.c.a(s)
return s},
mN(a){this.a.bb(new A.rz(this,a),new A.rA(this,a),t.P)}}
A.rz.prototype={
$1(a){this.a.b=a
this.b.$1(0)},
$S(){return this.a.$ti.h("F(1)")}}
A.rA.prototype={
$2(a,b){this.a.c=new A.a2(a,b)
this.b.$1(1)},
$S:7}
A.ry.prototype={
$1(a){var s=this.a,r=s.a+=a
if(++s.b===this.b.length)this.c.$1(r)},
$S:8}
A.dl.prototype={
b7(a,b){if((this.a.a&30)!==0)throw A.a(A.z("Future already completed"))
this.ac(A.ax(a,b))},
ab(a){return this.b7(a,null)},
$icW:1}
A.aa.prototype={
T(a){var s=this.a
if((s.a&30)!==0)throw A.a(A.z("Future already completed"))
s.aE(a)},
L(){return this.T(null)},
ac(a){this.a.S(a)}}
A.N.prototype={
T(a){var s=this.a
if((s.a&30)!==0)throw A.a(A.z("Future already completed"))
s.be(a)},
L(){return this.T(null)},
ac(a){this.a.ac(a)}}
A.bj.prototype={
oD(a){if((this.c&15)!==6)return!0
return this.b.b.dC(this.d,a.a,t.y,t.K)},
o4(a){var s,r=this.e,q=null,p=t.z,o=t.K,n=a.a,m=this.b.b
if(t.ng.b(r))q=m.hf(r,n,a.b,p,o,t.l)
else q=m.dC(r,n,p,o)
try{p=q
return p}catch(s){if(t.do.b(A.E(s))){if((this.c&1)!==0)throw A.a(A.J("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.a(A.J("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.l.prototype={
bb(a,b,c){var s,r,q=$.m
if(q===B.d){if(b!=null&&!t.ng.b(b)&&!t.mq.b(b))throw A.a(A.b_(b,"onError",u.w))}else{a=q.bM(a,c.h("0/"),this.$ti.c)
if(b!=null)b=A.yD(b,q)}s=new A.l($.m,c.h("l<0>"))
r=b==null?1:3
this.ck(new A.bj(s,r,a,b,this.$ti.h("@<1>").I(c).h("bj<1,2>")))
return s},
aK(a,b){return this.bb(a,null,b)},
iN(a,b,c){var s=new A.l($.m,c.h("l<0>"))
this.ck(new A.bj(s,19,a,b,this.$ti.h("@<1>").I(c).h("bj<1,2>")))
return s},
lN(){var s,r
if(((this.a|=1)&4)!==0){s=this
do s=s.c
while(r=s.a,(r&4)!==0)
s.a=r|1}},
j6(a){var s=this.$ti,r=$.m,q=new A.l(r,s)
if(r!==B.d)a=A.yD(a,r)
this.ck(new A.bj(q,2,null,a,s.h("bj<1,1>")))
return q},
J(a){var s=this.$ti,r=$.m,q=new A.l(r,s)
if(r!==B.d)a=r.b_(a,t.z)
this.ck(new A.bj(q,8,a,null,s.h("bj<1,1>")))
return q},
mz(a){this.a=this.a&1|16
this.c=a},
dO(a){this.a=a.a&30|this.a&1
this.c=a.c},
ck(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.ck(a)
return}s.dO(r)}s.b.bQ(new A.rB(s,a))}},
iq(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.iq(a)
return}n.dO(s)}m.a=n.dX(a)
n.b.bQ(new A.rG(m,n))}},
d0(){var s=this.c
this.c=null
return this.dX(s)},
dX(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
be(a){var s,r=this
if(r.$ti.h("o<1>").b(a))A.rE(a,r,!0)
else{s=r.d0()
r.a=8
r.c=a
A.dq(r,s)}},
bV(a){var s=this,r=s.d0()
s.a=8
s.c=a
A.dq(s,r)},
lp(a){var s,r,q,p=this
if((a.a&16)!==0){s=p.b
r=a.b
s=!(s===r||s.gbm()===r.gbm())}else s=!1
if(s)return
q=p.d0()
p.dO(a)
A.dq(p,q)},
ac(a){var s=this.d0()
this.mz(a)
A.dq(this,s)},
lo(a,b){this.ac(new A.a2(a,b))},
aE(a){if(this.$ti.h("o<1>").b(a)){this.hJ(a)
return}this.hH(a)},
hH(a){this.a^=2
this.b.bQ(new A.rD(this,a))},
hJ(a){A.rE(a,this,!1)
return},
S(a){this.a^=2
this.b.bQ(new A.rC(this,a))},
p_(a,b){var s,r,q,p=this,o={}
if((p.a&24)!==0){o=new A.l($.m,p.$ti)
o.aE(p)
return o}s=p.$ti
r=$.m
q=new A.l(r,s)
o.a=null
o.a=A.pA(a,new A.rM(p,q,r,r.b_(b,s.h("1/"))))
p.bb(new A.rN(o,p,q),new A.rO(o,q),t.P)
return q},
$io:1}
A.rB.prototype={
$0(){A.dq(this.a,this.b)},
$S:0}
A.rG.prototype={
$0(){A.dq(this.b,this.a.a)},
$S:0}
A.rF.prototype={
$0(){A.rE(this.a.a,this.b,!0)},
$S:0}
A.rD.prototype={
$0(){this.a.bV(this.b)},
$S:0}
A.rC.prototype={
$0(){this.a.ac(this.b)},
$S:0}
A.rJ.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.bv(q.d,t.z)}catch(p){s=A.E(p)
r=A.I(p)
if(k.c&&k.b.a.c.a===s){q=k.a
q.c=k.b.a.c}else{q=s
o=r
if(o==null)o=A.cN(q)
n=k.a
n.c=new A.a2(q,o)
q=n}q.b=!0
return}if(j instanceof A.l&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=j.c
q.b=!0}return}if(j instanceof A.l){m=k.b.a
l=new A.l(m.b,m.$ti)
j.bb(new A.rK(l,m),new A.rL(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.rK.prototype={
$1(a){this.a.lp(this.b)},
$S:12}
A.rL.prototype={
$2(a,b){this.a.ac(new A.a2(a,b))},
$S:7}
A.rI.prototype={
$0(){var s,r,q,p,o,n
try{q=this.a
p=q.a
o=p.$ti
q.c=p.b.b.dC(p.d,this.b,o.h("2/"),o.c)}catch(n){s=A.E(n)
r=A.I(n)
q=s
p=r
if(p==null)p=A.cN(q)
o=this.a
o.c=new A.a2(q,p)
o.b=!0}},
$S:0}
A.rH.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=l.a.a.c
p=l.b
if(p.a.oD(s)&&p.a.e!=null){p.c=p.a.o4(s)
p.b=!1}}catch(o){r=A.E(o)
q=A.I(o)
p=l.a.a.c
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.cN(p)
m=l.b
m.c=new A.a2(p,n)
p=m}p.b=!0}},
$S:0}
A.rM.prototype={
$0(){var s,r,q,p,o,n=this
try{n.b.be(n.c.bv(n.d,n.a.$ti.h("1/")))}catch(q){s=A.E(q)
r=A.I(q)
p=s
o=r
if(o==null)o=A.cN(p)
n.b.ac(new A.a2(p,o))}},
$S:0}
A.rN.prototype={
$1(a){var s=this.a.a
if(s.b!=null){s.u()
this.c.bV(a)}},
$S(){return this.b.$ti.h("F(1)")}}
A.rO.prototype={
$2(a,b){var s=this.a.a
if(s.b!=null){s.u()
this.b.ac(new A.a2(a,b))}},
$S:7}
A.jH.prototype={}
A.D.prototype={
gaw(){return!1},
n4(a,b){var s,r=null,q={}
q.a=null
s=this.gaw()?q.a=new A.du(r,r,b.h("du<0>")):q.a=new A.cD(r,r,r,r,b.h("cD<0>"))
s.sjE(new A.oP(q,this,a))
return q.a.gbB()},
nX(a,b,c,d){var s,r={},q=new A.l($.m,d.h("l<0>"))
r.a=b
s=this.B(null,!0,new A.oU(r,q),q.gf4())
s.bt(new A.oV(r,this,c,s,q,d))
return q},
gk(a){var s={},r=new A.l($.m,t.hy)
s.a=0
this.B(new A.oW(s,this),!0,new A.oX(s,r),r.gf4())
return r},
gai(a){var s=new A.l($.m,A.p(this).h("l<D.T>")),r=this.B(null,!0,new A.oQ(s),s.gf4())
r.bt(new A.oR(this,r,s))
return s}}
A.oP.prototype={
$0(){var s=this.b,r=this.a,q=r.a.gdN(),p=s.az(null,r.a.gaG(),q)
p.bt(new A.oO(r,s,this.c,p))
r.a.sjD(p.ge9())
if(!s.gaw()){s=r.a
s.sjF(p.geu())
s.sjG(p.gbN())}},
$S:0}
A.oO.prototype={
$1(a){var s,r,q,p,o,n,m,l=this,k=null
try{k=l.c.$1(a)}catch(p){s=A.E(p)
r=A.I(p)
o=s
n=r
m=A.dx(o,n)
if(m==null)m=new A.a2(o,n==null?A.cN(o):n)
q=m
l.a.a.ag(q.a,q.b)
return}if(k!=null){o=l.d
o.aj()
l.a.a.iZ(k).J(o.gbN())}},
$S(){return A.p(this.b).h("~(D.T)")}}
A.oU.prototype={
$0(){this.b.be(this.a.a)},
$S:0}
A.oV.prototype={
$1(a){var s=this,r=s.a,q=s.f
A.DH(new A.oS(r,s.c,a,q),new A.oT(r,q),A.CZ(s.d,s.e))},
$S(){return A.p(this.b).h("~(D.T)")}}
A.oS.prototype={
$0(){return this.b.$2(this.a.a,this.c)},
$S(){return this.d.h("0()")}}
A.oT.prototype={
$1(a){this.a.a=a},
$S(){return this.b.h("F(0)")}}
A.oW.prototype={
$1(a){++this.a.a},
$S(){return A.p(this.b).h("~(D.T)")}}
A.oX.prototype={
$0(){this.b.be(this.a.a)},
$S:0}
A.oQ.prototype={
$0(){var s,r=A.fH(),q=new A.aX("No element")
A.j0(q,r)
s=A.dx(q,r)
if(s==null)s=new A.a2(q,r)
this.a.ac(s)},
$S:0}
A.oR.prototype={
$1(a){A.D_(this.b,this.c,a)},
$S(){return A.p(this.a).h("~(D.T)")}}
A.fJ.prototype={
gaw(){return this.a.gaw()},
B(a,b,c,d){return this.a.B(a,b,c,d)},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.jk.prototype={}
A.cB.prototype={
gbB(){return new A.a4(this,A.p(this).h("a4<1>"))},
gma(){if((this.b&8)===0)return this.a
return this.a.c},
bX(){var s,r,q=this
if((q.b&8)===0){s=q.a
return s==null?q.a=new A.ey():s}r=q.a
s=r.c
return s==null?r.c=new A.ey():s},
ga6(){var s=this.a
return(this.b&8)!==0?s.c:s},
ap(){if((this.b&4)!==0)return new A.aX("Cannot add event after closing")
return new A.aX("Cannot add event while adding a stream")},
e6(a,b){var s,r,q,p=this,o=p.b
if(o>=4)throw A.a(p.ap())
if((o&2)!==0){o=new A.l($.m,t._)
o.aE(null)
return o}o=p.a
s=b===!0
r=new A.l($.m,t._)
q=s?A.BL(p):p.gdN()
q=a.B(p.geU(),s,p.gf_(),q)
s=p.b
if((s&1)!==0?(p.ga6().e&4)!==0:(s&2)===0)q.aj()
p.a=new A.ks(o,r,q)
p.b|=8
return r},
iZ(a){return this.e6(a,null)},
dQ(){var s=this.c
if(s==null)s=this.c=(this.b&2)!==0?$.cK():new A.l($.m,t.D)
return s},
q(a,b){if(this.b>=4)throw A.a(this.ap())
this.N(b)},
ag(a,b){var s
if(this.b>=4)throw A.a(this.ap())
s=A.ax(a,b)
this.a9(s.a,s.b)},
mZ(a){return this.ag(a,null)},
n(){var s=this,r=s.b
if((r&4)!==0)return s.dQ()
if(r>=4)throw A.a(s.ap())
s.hL()
return s.dQ()},
hL(){var s=this.b|=4
if((s&1)!==0)this.bE()
else if((s&3)===0)this.bX().q(0,B.z)},
N(a){var s=this.b
if((s&1)!==0)this.a1(a)
else if((s&3)===0)this.bX().q(0,new A.bx(a))},
a9(a,b){var s=this.b
if((s&1)!==0)this.bi(a,b)
else if((s&3)===0)this.bX().q(0,new A.en(a,b))},
Z(){var s=this.a
this.a=s.c
this.b&=4294967287
s.a.aE(null)},
fz(a,b,c,d){var s,r,q,p=this
if((p.b&3)!==0)throw A.a(A.z("Stream has already been listened to."))
s=A.C2(p,a,b,c,d,A.p(p).c)
r=p.gma()
if(((p.b|=1)&8)!==0){q=p.a
q.c=s
q.b.am()}else p.a=s
s.mA(r)
s.fd(new A.tr(p))
return s},
it(a){var s,r,q,p,o,n,m,l=this,k=null
if((l.b&8)!==0)k=l.a.u()
l.a=null
l.b=l.b&4294967286|2
s=l.r
if(s!=null)if(k==null)try{r=s.$0()
if(r instanceof A.l)k=r}catch(o){q=A.E(o)
p=A.I(o)
n=new A.l($.m,t.D)
n.S(new A.a2(q,p))
k=n}else k=k.J(s)
m=new A.tq(l)
if(k!=null)k=k.J(m)
else m.$0()
return k},
iu(a){if((this.b&8)!==0)this.a.b.aj()
A.kO(this.e)},
iv(a){if((this.b&8)!==0)this.a.b.am()
A.kO(this.f)},
$iaj:1,
$ibH:1,
sjE(a){return this.d=a},
sjF(a){return this.e=a},
sjG(a){return this.f=a},
sjD(a){return this.r=a}}
A.tr.prototype={
$0(){A.kO(this.a.d)},
$S:0}
A.tq.prototype={
$0(){var s=this.a.c
if(s!=null&&(s.a&30)===0)s.aE(null)},
$S:0}
A.kw.prototype={
a1(a){this.ga6().N(a)},
bi(a,b){this.ga6().a9(a,b)},
bE(){this.ga6().Z()}}
A.jJ.prototype={
a1(a){this.ga6().bd(new A.bx(a))},
bi(a,b){this.ga6().bd(new A.en(a,b))},
bE(){this.ga6().bd(B.z)}}
A.bL.prototype={}
A.cD.prototype={}
A.a4.prototype={
gv(a){return(A.e0(this.a)^892482866)>>>0},
D(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.a4&&b.a===this.a}}
A.cA.prototype={
dV(){return this.w.it(this)},
b2(){this.w.iu(this)},
b3(){this.w.iv(this)}}
A.h_.prototype={
u(){var s=this.b.u()
return s.J(new A.qB(this))}}
A.qC.prototype={
$2(a,b){var s=this.a
s.a9(a,b)
s.Z()},
$S:7}
A.qB.prototype={
$0(){this.a.a.aE(null)},
$S:1}
A.ks.prototype={}
A.aw.prototype={
mA(a){var s=this
if(a==null)return
s.r=a
if(a.c!=null){s.e=(s.e|128)>>>0
a.dI(s)}},
bt(a){this.a=A.jL(this.d,a,A.p(this).h("aw.T"))},
ds(a){var s=this,r=s.e
if(a==null)s.e=(r&4294967263)>>>0
else s.e=(r|32)>>>0
s.b=A.jM(s.d,a)},
aJ(a){var s,r=this,q=r.e
if((q&8)!==0)return
r.e=(q+256|4)>>>0
if(a!=null)a.J(r.gbN())
if(q<256){s=r.r
if(s!=null)if(s.a===1)s.a=3}if((q&4)===0&&(r.e&64)===0)r.fd(r.gcX())},
aj(){return this.aJ(null)},
am(){var s=this,r=s.e
if((r&8)!==0)return
if(r>=256){r=s.e=r-256
if(r<256)if((r&128)!==0&&s.r.c!=null)s.r.dI(s)
else{r=(r&4294967291)>>>0
s.e=r
if((r&64)===0)s.fd(s.gcY())}}},
u(){var s=this,r=(s.e&4294967279)>>>0
s.e=r
if((r&8)===0)s.eX()
r=s.f
return r==null?$.cK():r},
eX(){var s,r=this,q=r.e=(r.e|8)>>>0
if((q&128)!==0){s=r.r
if(s.a===1)s.a=3}if((q&64)===0)r.r=null
r.f=r.dV()},
N(a){var s=this.e
if((s&8)!==0)return
if(s<64)this.a1(a)
else this.bd(new A.bx(a))},
a9(a,b){var s
if(t.C.b(a))A.j0(a,b)
s=this.e
if((s&8)!==0)return
if(s<64)this.bi(a,b)
else this.bd(new A.en(a,b))},
Z(){var s=this,r=s.e
if((r&8)!==0)return
r=(r|2)>>>0
s.e=r
if(r<64)s.bE()
else s.bd(B.z)},
b2(){},
b3(){},
dV(){return null},
bd(a){var s,r=this,q=r.r
if(q==null)q=r.r=new A.ey()
q.q(0,a)
s=r.e
if((s&128)===0){s=(s|128)>>>0
r.e=s
if(s<256)q.dI(r)}},
a1(a){var s=this,r=s.e
s.e=(r|64)>>>0
s.d.ca(s.a,a,A.p(s).h("aw.T"))
s.e=(s.e&4294967231)>>>0
s.eZ((r&4)!==0)},
bi(a,b){var s,r=this,q=r.e,p=new A.qX(r,a,b)
if((q&1)!==0){r.e=(q|16)>>>0
r.eX()
s=r.f
if(s!=null&&s!==$.cK())s.J(p)
else p.$0()}else{p.$0()
r.eZ((q&4)!==0)}},
bE(){var s,r=this,q=new A.qW(r)
r.eX()
r.e=(r.e|16)>>>0
s=r.f
if(s!=null&&s!==$.cK())s.J(q)
else q.$0()},
fd(a){var s=this,r=s.e
s.e=(r|64)>>>0
a.$0()
s.e=(s.e&4294967231)>>>0
s.eZ((r&4)!==0)},
eZ(a){var s,r,q=this,p=q.e
if((p&128)!==0&&q.r.c==null){p=q.e=(p&4294967167)>>>0
s=!1
if((p&4)!==0)if(p<256){s=q.r
s=s==null?null:s.c==null
s=s!==!1}if(s){p=(p&4294967291)>>>0
q.e=p}}for(;;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=(p^64)>>>0
if(r)q.b2()
else q.b3()
p=(q.e&4294967231)>>>0
q.e=p}if((p&128)!==0&&p<256)q.r.dI(q)},
$iae:1}
A.qX.prototype={
$0(){var s,r,q,p=this.a,o=p.e
if((o&8)!==0&&(o&16)===0)return
p.e=(o|64)>>>0
s=p.b
o=this.b
r=t.K
q=p.d
if(t.r.b(s))q.hg(s,o,this.c,r,t.l)
else q.ca(s,o,r)
p.e=(p.e&4294967231)>>>0},
$S:0}
A.qW.prototype={
$0(){var s=this.a,r=s.e
if((r&16)===0)return
s.e=(r|74)>>>0
s.d.dB(s.c)
s.e=(s.e&4294967231)>>>0},
$S:0}
A.eC.prototype={
B(a,b,c,d){return this.a.fz(a,d,c,b===!0)},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.jT.prototype={
gbs(){return this.a},
sbs(a){return this.a=a}}
A.bx.prototype={
hd(a){a.a1(this.b)}}
A.en.prototype={
hd(a){a.bi(this.b,this.c)}}
A.rq.prototype={
hd(a){a.bE()},
gbs(){return null},
sbs(a){throw A.a(A.z("No events after a done."))}}
A.ey.prototype={
dI(a){var s=this,r=s.a
if(r===1)return
if(r>=1){s.a=1
return}A.eT(new A.tb(s,a))
s.a=1},
q(a,b){var s=this,r=s.c
if(r==null)s.b=s.c=b
else{r.sbs(b)
s.c=b}}}
A.tb.prototype={
$0(){var s,r,q=this.a,p=q.a
q.a=0
if(p===3)return
s=q.b
r=s.gbs()
q.b=r
if(r==null)q.c=null
s.hd(this.b)},
$S:0}
A.eo.prototype={
bt(a){},
ds(a){},
aJ(a){var s=this.a
if(s>=0){this.a=s+2
if(a!=null)a.J(this.gbN())}},
aj(){return this.aJ(null)},
am(){var s=this,r=s.a-2
if(r<0)return
if(r===0){s.a=1
A.eT(s.gim())}else s.a=r},
u(){this.a=-1
this.c=null
return $.cK()},
m9(){var s,r=this,q=r.a-1
if(q===0){r.a=-1
s=r.c
if(s!=null){r.c=null
r.b.dB(s)}}else r.a=q},
$iae:1}
A.bP.prototype={
gp(){if(this.c)return this.b
return null},
m(){var s,r=this,q=r.a
if(q!=null){if(r.c){s=new A.l($.m,t.B)
r.b=s
r.c=!1
q.am()
return s}throw A.a(A.z("Already waiting for next."))}return r.lO()},
lO(){var s,r,q=this,p=q.b
if(p!=null){s=new A.l($.m,t.B)
q.b=s
r=p.B(q.gm1(),!0,q.gm3(),q.gm5())
if(q.b!=null)q.a=r
return s}return $.zl()},
u(){var s=this,r=s.a,q=s.b
s.b=null
if(r!=null){s.a=null
if(!s.c)q.aE(!1)
else s.c=!1
return r.u()}return $.cK()},
m2(a){var s,r,q=this
if(q.a==null)return
s=q.b
q.b=a
q.c=!0
s.be(!0)
if(q.c){r=q.a
if(r!=null)r.aj()}},
m6(a,b){var s=this,r=s.a,q=s.b
s.b=s.a=null
if(r!=null)q.ac(new A.a2(a,b))
else q.S(new A.a2(a,b))},
m4(){var s=this,r=s.a,q=s.b
s.b=s.a=null
if(r!=null)q.bV(!1)
else q.hH(!1)}}
A.dp.prototype={
B(a,b,c,d){return A.xQ(c,this.$ti.c)},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)},
gaw(){return!0}}
A.bz.prototype={
B(a,b,c,d){var s=null,r=new A.hh(s,s,s,s,this.$ti.h("hh<1>"))
r.d=new A.t9(this,r)
return r.fz(a,d,c,b===!0)},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)},
gaw(){return this.a}}
A.t9.prototype={
$0(){this.a.b.$1(this.b)},
$S:0}
A.hh.prototype={
n2(a){var s=this.b
if(s>=4)throw A.a(this.ap())
if((s&1)!==0)this.ga6().N(a)},
n_(a,b){var s=this.b
if(s>=4)throw A.a(this.ap())
if((s&1)!==0){s=this.ga6()
s.a9(a,b==null?B.t:b)}},
j8(){var s=this,r=s.b
if((r&4)!==0)return
if(r>=4)throw A.a(s.ap())
r|=4
s.b=r
if((r&1)!==0)s.ga6().Z()},
$ibZ:1}
A.u5.prototype={
$0(){return this.a.ac(this.b)},
$S:0}
A.u4.prototype={
$2(a,b){A.CY(this.a,this.b,new A.a2(a,b))},
$S:6}
A.u6.prototype={
$0(){return this.a.be(this.b)},
$S:0}
A.bb.prototype={
gaw(){return this.a.gaw()},
B(a,b,c,d){var s=A.p(this),r=$.m,q=b===!0?1:0,p=d!=null?32:0,o=A.jL(r,a,s.h("bb.T")),n=A.jM(r,d),m=c==null?A.uz():c
s=new A.es(this,o,n,r.b_(m,t.H),r,q|p,s.h("es<bb.S,bb.T>"))
s.x=this.a.az(s.gfe(),s.gfg(),s.gfi())
return s},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.es.prototype={
N(a){if((this.e&2)!==0)return
this.bT(a)},
a9(a,b){if((this.e&2)!==0)return
this.eR(a,b)},
b2(){var s=this.x
if(s!=null)s.aj()},
b3(){var s=this.x
if(s!=null)s.am()},
dV(){var s=this.x
if(s!=null){this.x=null
return s.u()}return null},
ff(a){this.w.ic(a,this)},
fj(a,b){this.a9(a,b)},
fh(){this.Z()}}
A.ce.prototype={
ic(a,b){var s,r,q,p=null
try{p=this.b.$1(a)}catch(q){s=A.E(q)
r=A.I(q)
A.yl(b,s,r)
return}if(p)b.N(a)}}
A.aM.prototype={
ic(a,b){var s,r,q,p=null
try{p=this.b.$1(a)}catch(q){s=A.E(q)
r=A.I(q)
A.yl(b,s,r)
return}b.N(p)}}
A.ha.prototype={
q(a,b){var s=this.a
if((s.e&2)!==0)A.r(A.z("Stream is already closed"))
s.bT(b)},
ag(a,b){this.a.a9(a,b)},
n(){var s=this.a
if((s.e&2)!==0)A.r(A.z("Stream is already closed"))
s.hA()},
$iaj:1}
A.eA.prototype={
N(a){if((this.e&2)!==0)throw A.a(A.z("Stream is already closed"))
this.bT(a)},
a9(a,b){if((this.e&2)!==0)throw A.a(A.z("Stream is already closed"))
this.eR(a,b)},
Z(){if((this.e&2)!==0)throw A.a(A.z("Stream is already closed"))
this.hA()},
b2(){var s=this.x
if(s!=null)s.aj()},
b3(){var s=this.x
if(s!=null)s.am()},
dV(){var s=this.x
if(s!=null){this.x=null
return s.u()}return null},
ff(a){var s,r,q,p
try{q=this.w
q===$&&A.L()
q.q(0,a)}catch(p){s=A.E(p)
r=A.I(p)
this.a9(s,r)}},
fj(a,b){var s,r,q,p
try{q=this.w
q===$&&A.L()
q.ag(a,b)}catch(p){s=A.E(p)
r=A.I(p)
if(s===a)this.a9(a,b)
else this.a9(s,r)}},
fh(){var s,r,q,p
try{this.x=null
q=this.w
q===$&&A.L()
q.n()}catch(p){s=A.E(p)
r=A.I(p)
this.a9(s,r)}}}
A.c8.prototype={
gaw(){return this.b.gaw()},
B(a,b,c,d){var s=this.$ti,r=$.m,q=b===!0?1:0,p=d!=null?32:0,o=A.jL(r,a,s.y[1]),n=A.jM(r,d),m=c==null?A.uz():c,l=new A.eA(o,n,r.b_(m,t.H),r,q|p,s.h("eA<1,2>"))
l.w=this.a.$1(new A.ha(l))
l.x=this.b.az(l.gfe(),l.gfg(),l.gfi())
return l},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.kr.prototype={
bj(a){return this.a.$1(a)}}
A.tX.prototype={}
A.tZ.prototype={}
A.tY.prototype={}
A.tV.prototype={}
A.tW.prototype={}
A.tU.prototype={}
A.tR.prototype={}
A.kG.prototype={}
A.tQ.prototype={}
A.tP.prototype={}
A.tT.prototype={}
A.tS.prototype={}
A.kF.prototype={
nY(a,b,c,d,e){return this.b.$5(a,b,c,d,e)}}
A.kH.prototype={}
A.kE.prototype={
cZ(a,b,c){var s,r,q,p,o,n,m=this.gfl(),l=m.a
if(l===B.d){A.hK(b,c)
return}o=l.gha()
o.toString
s=o
r=$.m
try{$.m=s
m.nY(l,l.gaO(),a,b,c)
$.m=r}catch(n){q=A.E(n)
p=A.I(n)
$.m=r
o=b===q?c:p
s.cZ(l,q,o)}},
$iB:1}
A.jR.prototype={
ghY(){var s=this.ax
return s==null?this.ax=new A.eH(this):s},
gaO(){return this.ay.ghY()},
gbm(){return this.as.a},
dB(a){var s,r,q
try{this.bv(a,t.H)}catch(q){s=A.E(q)
r=A.I(q)
this.cZ(this,s,r)}},
ca(a,b,c){var s,r,q
try{this.dC(a,b,t.H,c)}catch(q){s=A.E(q)
r=A.I(q)
this.cZ(this,s,r)}},
hg(a,b,c,d,e){var s,r,q
try{this.hf(a,b,c,t.H,d,e)}catch(q){s=A.E(q)
r=A.I(q)
this.cZ(this,s,r)}},
fJ(a,b){return new A.rl(this,this.b_(a,b),b)},
d9(a){return new A.rk(this,this.b_(a,t.H))},
fK(a,b){return new A.rm(this,this.bM(a,t.H,b),b)},
i(a,b){var s,r,q=this.at
if(q===B.a0)return null
s=q.b
r=s.i(0,b)
return r!=null||s.E(b)?r:this.mi(q,b)},
mi(a,b){var s,r,q
for(s=a,r=null;;){s=s.a.gha().gfF()
if(s===B.a0)break
q=s.b
r=q.i(0,b)
if(r!=null||q.E(b)){a.b.l(0,b,r)
break}}return r},
c7(a,b){this.cZ(this,a,b)},
eh(a,b){var s=this.Q,r=s.a
return s.b.$5(r,r.gaO(),this,a,b)},
jo(a){return this.eh(null,a)},
bv(a,b){var s=this.a,r=s.a
return s.b.$1$4(r,r.gaO(),this,a,b)},
dC(a,b,c,d){var s=this.b,r=s.a
return s.b.$2$5(r,r.gaO(),this,a,b,c,d)},
hf(a,b,c,d,e,f){var s=this.c,r=s.a
return s.b.$3$6(r,r.gaO(),this,a,b,c,d,e,f)},
b_(a,b){var s=this.d,r=s.a
return s.b.$1$4(r,r.gaO(),this,a,b)},
bM(a,b,c){var s=this.e,r=s.a
return s.b.$2$4(r,r.gaO(),this,a,b,c)},
cE(a,b,c,d){var s=this.f,r=s.a
return s.b.$3$4(r,r.gaO(),this,a,b,c,d)},
jg(a,b){var s=this.r,r=s.a
if(r===B.d)return null
return s.b.$5(r,r.gaO(),this,a,b)},
bQ(a){var s=this.w,r=s.a
return s.b.$4(r,r.gaO(),this,a)},
fO(a,b){var s=this.x,r=s.a
return s.b.$5(r,r.gaO(),this,a,b)},
giD(){return this.a},
giF(){return this.b},
giE(){return this.c},
gix(){return this.d},
giy(){return this.e},
giw(){return this.f},
gi0(){return this.r},
gfv(){return this.w},
ghV(){return this.x},
ghU(){return this.y},
gir(){return this.z},
gi5(){return this.Q},
gfl(){return this.as},
gfF(){return this.at},
gha(){return this.ay}}
A.rl.prototype={
$0(){return this.a.bv(this.b,this.c)},
$S(){return this.c.h("0()")}}
A.rk.prototype={
$0(){return this.a.dB(this.b)},
$S:0}
A.rm.prototype={
$1(a){return this.a.ca(this.b,a,this.c)},
$S(){return this.c.h("~(0)")}}
A.kn.prototype={
giD(){return B.ca},
giF(){return B.c9},
giE(){return B.c8},
gix(){return B.c6},
giy(){return B.c7},
giw(){return B.c5},
gi0(){return B.c1},
gfv(){return B.cb},
ghV(){return B.c0},
ghU(){return B.b6},
gir(){return B.c4},
gi5(){return B.c2},
gfl(){return B.c3},
gfF(){return B.a0},
gha(){return null},
ghY(){var s=$.te
return s==null?$.te=new A.eH(this):s},
gaO(){var s=$.te
return s==null?$.te=new A.eH(this):s},
gbm(){return this},
dB(a){var s,r,q
try{if(B.d===$.m){a.$0()
return}A.uj(null,null,this,a)}catch(q){s=A.E(q)
r=A.I(q)
A.hK(s,r)}},
ca(a,b){var s,r,q
try{if(B.d===$.m){a.$1(b)
return}A.uk(null,null,this,a,b)}catch(q){s=A.E(q)
r=A.I(q)
A.hK(s,r)}},
hg(a,b,c){var s,r,q
try{if(B.d===$.m){a.$2(b,c)
return}A.wd(null,null,this,a,b,c)}catch(q){s=A.E(q)
r=A.I(q)
A.hK(s,r)}},
fJ(a,b){return new A.tg(this,a,b)},
d9(a){return new A.tf(this,a)},
fK(a,b){return new A.th(this,a,b)},
i(a,b){return null},
c7(a,b){A.hK(a,b)},
eh(a,b){return A.yF(null,null,this,a,b)},
jo(a){return this.eh(null,a)},
bv(a){if($.m===B.d)return a.$0()
return A.uj(null,null,this,a)},
dC(a,b){if($.m===B.d)return a.$1(b)
return A.uk(null,null,this,a,b)},
hf(a,b,c){if($.m===B.d)return a.$2(b,c)
return A.wd(null,null,this,a,b,c)},
b_(a){return a},
bM(a){return a},
cE(a){return a},
jg(a,b){return null},
bQ(a){A.ul(null,null,this,a)},
fO(a,b){return A.vG(a,b)}}
A.tg.prototype={
$0(){return this.a.bv(this.b,this.c)},
$S(){return this.c.h("0()")}}
A.tf.prototype={
$0(){return this.a.dB(this.b)},
$S:0}
A.th.prototype={
$1(a){return this.a.ca(this.b,a,this.c)},
$S(){return this.c.h("~(0)")}}
A.eH.prototype={$ia9:1}
A.ui.prototype={
$0(){A.il(this.a,this.b)},
$S:0}
A.fY.prototype={}
A.cb.prototype={
gk(a){return this.a},
gF(a){return this.a===0},
ga3(){return new A.hc(this,A.p(this).h("hc<1>"))},
E(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.hS(a)},
hS(a){var s=this.d
if(s==null)return!1
return this.bf(this.hP(s,a),a)>=0},
aa(a,b){b.ad(0,new A.rP(this))},
i(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.xT(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.xT(q,b)
return r}else return this.i8(b)},
i8(a){var s,r,q=this.d
if(q==null)return null
s=this.hP(q,a)
r=this.bf(s,a)
return r<0?null:s[r+1]},
l(a,b,c){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
q.hN(s==null?q.b=A.vT():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
q.hN(r==null?q.c=A.vT():r,b,c)}else q.iG(b,c)},
iG(a,b){var s,r,q,p=this,o=p.d
if(o==null)o=p.d=A.vT()
s=p.bC(a)
r=o[s]
if(r==null){A.vU(o,s,[a,b]);++p.a
p.e=null}else{q=p.bf(r,a)
if(q>=0)r[q+1]=b
else{r.push(a,b);++p.a
p.e=null}}},
ad(a,b){var s,r,q,p,o,n=this,m=n.hO()
for(s=m.length,r=A.p(n).y[1],q=0;q<s;++q){p=m[q]
o=n.i(0,p)
b.$2(p,o==null?r.a(o):o)
if(m!==n.e)throw A.a(A.ao(n))}},
hO(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.b7(i.a,null,!1,t.z)
s=i.b
r=0
if(s!=null){q=Object.getOwnPropertyNames(s)
p=q.length
for(o=0;o<p;++o){h[r]=q[o];++r}}n=i.c
if(n!=null){q=Object.getOwnPropertyNames(n)
p=q.length
for(o=0;o<p;++o){h[r]=+q[o];++r}}m=i.d
if(m!=null){q=Object.getOwnPropertyNames(m)
p=q.length
for(o=0;o<p;++o){l=m[q[o]]
k=l.length
for(j=0;j<k;j+=2){h[r]=l[j];++r}}}return i.e=h},
hN(a,b,c){if(a[b]==null){++this.a
this.e=null}A.vU(a,b,c)},
bC(a){return J.V(a)&1073741823},
hP(a,b){return a[this.bC(b)]},
bf(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2)if(J.A(a[r],b))return r
return-1}}
A.rP.prototype={
$2(a,b){this.a.l(0,a,b)},
$S(){return A.p(this.a).h("~(1,2)")}}
A.dr.prototype={
bC(a){return A.kT(a)&1073741823},
bf(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.h5.prototype={
i(a,b){if(!this.w.$1(b))return null
return this.kU(b)},
l(a,b,c){this.kV(b,c)},
E(a){if(!this.w.$1(a))return!1
return this.kT(a)},
bC(a){return this.r.$1(a)&1073741823},
bf(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=this.f,q=0;q<s;q+=2)if(r.$2(a[q],b))return q
return-1}}
A.rj.prototype={
$1(a){return this.a.b(a)},
$S:17}
A.hc.prototype={
gk(a){return this.a.a},
gF(a){return this.a.a===0},
gaP(a){return this.a.a!==0},
gA(a){var s=this.a
return new A.jZ(s,s.hO(),this.$ti.h("jZ<1>"))},
U(a,b){return this.a.E(b)}}
A.jZ.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.a(A.ao(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}}}
A.hg.prototype={
i(a,b){if(!this.y.$1(b))return null
return this.kK(b)},
l(a,b,c){this.kM(b,c)},
E(a){if(!this.y.$1(a))return!1
return this.kJ(a)},
H(a,b){if(!this.y.$1(b))return null
return this.kL(b)},
dn(a){return this.x.$1(a)&1073741823},
cz(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=this.w,q=0;q<s;++q)if(r.$2(a[q].a,b))return q
return-1}}
A.t7.prototype={
$1(a){return this.a.b(a)},
$S:17}
A.cc.prototype={
m0(){return new A.cc(A.p(this).h("cc<1>"))},
gA(a){var s=this,r=new A.ev(s,s.r,A.p(s).h("ev<1>"))
r.c=s.e
return r},
gk(a){return this.a},
gF(a){return this.a===0},
gaP(a){return this.a!==0},
U(a,b){var s,r
if(typeof b=="string"&&b!=="__proto__"){s=this.b
if(s==null)return!1
return s[b]!=null}else{r=this.ls(b)
return r}},
ls(a){var s=this.d
if(s==null)return!1
return this.bf(s[this.bC(a)],a)>=0},
q(a,b){var s,r,q=this
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.hM(s==null?q.b=A.vW():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.hM(r==null?q.c=A.vW():r,b)}else return q.lm(b)},
lm(a){var s,r,q=this,p=q.d
if(p==null)p=q.d=A.vW()
s=q.bC(a)
r=p[s]
if(r==null)p[s]=[q.f2(a)]
else{if(q.bf(r,a)>=0)return!1
r.push(q.f2(a))}return!0},
H(a,b){var s=this
if(typeof b=="string"&&b!=="__proto__")return s.hQ(s.b,b)
else if(typeof b=="number"&&(b&1073741823)===b)return s.hQ(s.c,b)
else return s.fu(b)},
fu(a){var s,r,q,p,o=this,n=o.d
if(n==null)return!1
s=o.bC(a)
r=n[s]
q=o.bf(r,a)
if(q<0)return!1
p=r.splice(q,1)[0]
if(0===r.length)delete n[s]
o.hR(p)
return!0},
au(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.f1()}},
hM(a,b){if(a[b]!=null)return!1
a[b]=this.f2(b)
return!0},
hQ(a,b){var s
if(a==null)return!1
s=a[b]
if(s==null)return!1
this.hR(s)
delete a[b]
return!0},
f1(){this.r=this.r+1&1073741823},
f2(a){var s,r=this,q=new A.t8(a)
if(r.e==null)r.e=r.f=q
else{s=r.f
s.toString
q.c=s
r.f=s.b=q}++r.a
r.f1()
return q},
hR(a){var s=this,r=a.c,q=a.b
if(r==null)s.e=q
else r.b=q
if(q==null)s.f=r
else q.c=r;--s.a
s.f1()},
bC(a){return J.V(a)&1073741823},
bf(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.A(a[r].a,b))return r
return-1}}
A.t8.prototype={}
A.ev.prototype={
gp(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.a(A.ao(q))
else if(r==null){s.d=null
return!1}else{s.d=r.a
s.c=r.b
return!0}}}
A.nN.prototype={
$2(a,b){this.a.l(0,this.b.a(a),this.c.a(b))},
$S:158}
A.d1.prototype={
U(a,b){return!1},
gA(a){var s=this
return new A.k5(s,s.a,s.c,s.$ti.h("k5<1>"))},
gk(a){return this.b},
au(a){var s,r,q,p=this;++p.a
if(p.b===0)return
s=p.c
s.toString
r=s
do{q=r.b
q.toString
r.b=r.c=r.a=null
if(q!==s){r=q
continue}else break}while(!0)
p.c=null
p.b=0},
gai(a){var s
if(this.b===0)throw A.a(A.z("No such element"))
s=this.c
s.toString
return s},
gaQ(a){var s
if(this.b===0)throw A.a(A.z("No such element"))
s=this.c.c
s.toString
return s},
gF(a){return this.b===0},
dS(a,b,c){var s,r,q=this
if(b.a!=null)throw A.a(A.z("LinkedListEntry is already in a LinkedList"));++q.a
b.a=q
s=q.b
if(s===0){b.b=b
q.c=b.c=b
q.b=s+1
return}r=a.c
r.toString
b.c=r
b.b=a
a.c=r.b=b
q.b=s+1},
fB(a){var s,r,q=this;++q.a
s=a.b
s.c=a.c
a.c.b=s
r=--q.b
a.a=a.b=a.c=null
if(r===0)q.c=null
else if(a===q.c)q.c=s}}
A.k5.prototype={
gp(){var s=this.c
return s==null?this.$ti.c.a(s):s},
m(){var s=this,r=s.a
if(s.b!==r.a)throw A.a(A.ao(s))
if(r.b!==0)r=s.e&&s.d===r.gai(0)
else r=!0
if(r){s.c=null
return!1}s.e=!0
r=s.d
s.c=r
s.d=r.b
return!0}}
A.aH.prototype={
gdu(){var s=this.a
if(s==null||this===s.gai(0))return null
return this.c}}
A.y.prototype={
gA(a){return new A.at(a,this.gk(a),A.bo(a).h("at<y.E>"))},
V(a,b){return this.i(a,b)},
gF(a){return this.gk(a)===0},
gaP(a){return!this.gF(a)},
gai(a){if(this.gk(a)===0)throw A.a(A.bW())
return this.i(a,0)},
U(a,b){var s,r=this.gk(a)
for(s=0;s<r;++s){if(J.A(this.i(a,s),b))return!0
if(r!==this.gk(a))throw A.a(A.ao(a))}return!1},
b9(a,b,c){return new A.a8(a,b,A.bo(a).h("@<y.E>").I(c).h("a8<1,2>"))},
aU(a,b){return A.bK(a,b,null,A.bo(a).h("y.E"))},
bO(a,b){return A.bK(a,0,A.bd(b,"count",t.S),A.bo(a).h("y.E"))},
q(a,b){var s=this.gk(a)
this.sk(a,s+1)
this.l(a,s,b)},
ea(a,b){return new A.ag(a,A.bo(a).h("@<y.E>").I(b).h("ag<1,2>"))},
cP(a,b){var s=b==null?A.Ef():b
A.ja(a,0,this.gk(a)-1,s)},
kv(a,b,c){A.aJ(b,c,this.gk(a))
return A.bK(a,b,c,A.bo(a).h("y.E"))},
fT(a,b,c,d){var s
A.aJ(b,c,this.gk(a))
for(s=b;s<c;++s)this.l(a,s,d)},
X(a,b,c,d,e){var s,r,q,p,o
A.aJ(b,c,this.gk(a))
s=c-b
if(s===0)return
A.aI(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.l1(d,e).cb(0,!1)
r=0}p=J.ab(q)
if(r+s>p.gk(q))throw A.a(A.wY())
if(r<b)for(o=s-1;o>=0;--o)this.l(a,b+o,p.i(q,r+o))
else for(o=0;o<s;++o)this.l(a,b+o,p.i(q,r+o))},
af(a,b,c,d){return this.X(a,b,c,d,0)},
cM(a,b,c){var s,r
if(t.j.b(c))this.af(a,b,b+c.length,c)
else for(s=J.Z(c);s.m();b=r){r=b+1
this.l(a,b,s.gp())}},
j(a){return A.nH(a,"[","]")},
$ix:1,
$in:1,
$it:1}
A.G.prototype={
bk(a,b,c){var s=A.p(this)
return A.x6(this,s.h("G.K"),s.h("G.V"),b,c)},
ad(a,b){var s,r,q,p
for(s=J.Z(this.ga3()),r=A.p(this).h("G.V");s.m();){q=s.gp()
p=this.i(0,q)
b.$2(q,p==null?r.a(p):p)}},
gbl(){return J.dE(this.ga3(),new A.nR(this),A.p(this).h("M<G.K,G.V>"))},
cB(a,b,c,d){var s,r,q,p,o,n=A.T(c,d)
for(s=J.Z(this.ga3()),r=A.p(this).h("G.V");s.m();){q=s.gp()
p=this.i(0,q)
o=b.$2(q,p==null?r.a(p):p)
n.l(0,o.a,o.b)}return n},
E(a){return J.wy(this.ga3(),a)},
gk(a){return J.aN(this.ga3())},
gF(a){return J.l0(this.ga3())},
j(a){return A.nS(this)},
$ia_:1}
A.nR.prototype={
$1(a){var s=this.a,r=s.i(0,a)
if(r==null)r=A.p(s).h("G.V").a(r)
return new A.M(a,r,A.p(s).h("M<G.K,G.V>"))},
$S(){return A.p(this.a).h("M<G.K,G.V>(G.K)")}}
A.nT.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.q(a)
r.a=(r.a+=s)+": "
s=A.q(b)
r.a+=s},
$S:54}
A.kA.prototype={
l(a,b,c){throw A.a(A.P("Cannot modify unmodifiable map"))}}
A.fs.prototype={
bk(a,b,c){return this.a.bk(0,b,c)},
i(a,b){return this.a.i(0,b)},
l(a,b,c){this.a.l(0,b,c)},
E(a){return this.a.E(a)},
ad(a,b){this.a.ad(0,b)},
gF(a){var s=this.a
return s.gF(s)},
gk(a){var s=this.a
return s.gk(s)},
ga3(){return this.a.ga3()},
j(a){return this.a.j(0)},
gbl(){return this.a.gbl()},
cB(a,b,c,d){return this.a.cB(0,b,c,d)},
$ia_:1}
A.df.prototype={
bk(a,b,c){return new A.df(this.a.bk(0,b,c),b.h("@<0>").I(c).h("df<1,2>"))}}
A.fq.prototype={
gA(a){var s=this
return new A.k6(s,s.c,s.d,s.b,s.$ti.h("k6<1>"))},
gF(a){return this.b===this.c},
gk(a){return(this.c-this.b&this.a.length-1)>>>0},
V(a,b){var s,r=this
A.AF(b,r.gk(0),r,null,null)
s=r.a
s=s[(r.b+b&s.length-1)>>>0]
return s==null?r.$ti.c.a(s):s},
H(a,b){var s,r=this
for(s=r.b;s!==r.c;s=(s+1&r.a.length-1)>>>0)if(J.A(r.a[s],b)){r.fu(s);++r.d
return!0}return!1},
j(a){return A.nH(this,"{","}")},
fu(a){var s,r,q,p=this,o=p.a,n=o.length-1,m=p.b,l=p.c
if((a-m&n)>>>0<(l-a&n)>>>0){for(s=a;s!==m;s=r){r=(s-1&n)>>>0
o[s]=o[r]}o[m]=null
p.b=(m+1&n)>>>0
return(a+1&n)>>>0}else{m=p.c=(l-1&n)>>>0
for(s=a;s!==m;s=q){q=(s+1&n)>>>0
o[s]=o[q]}o[m]=null
return a}}}
A.k6.prototype={
gp(){var s=this.e
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a
if(r.c!==q.d)A.r(A.ao(q))
s=r.d
if(s===r.b){r.e=null
return!1}q=q.a
r.e=q[s]
r.d=(s+1&q.length-1)>>>0
return!0}}
A.cu.prototype={
gF(a){return this.gk(this)===0},
gaP(a){return this.gk(this)!==0},
aa(a,b){var s
for(s=J.Z(b);s.m();)this.q(0,s.gp())},
cH(a){var s=this.dD(0)
s.aa(0,a)
return s},
b9(a,b,c){return new A.bU(this,b,A.p(this).h("@<1>").I(c).h("bU<1,2>"))},
j(a){return A.nH(this,"{","}")},
bO(a,b){return A.xy(this,b,A.p(this).c)},
aU(a,b){return A.xr(this,b,A.p(this).c)},
V(a,b){var s,r
A.aI(b,"index")
s=this.gA(this)
for(r=b;s.m();){if(r===0)return s.gp();--r}throw A.a(A.iu(b,b-r,this,null,"index"))},
$ix:1,
$in:1,
$ibu:1}
A.ht.prototype={
dD(a){var s=this.m0()
s.aa(0,this)
return s}}
A.hC.prototype={}
A.k2.prototype={
i(a,b){var s,r=this.b
if(r==null)return this.c.i(0,b)
else if(typeof b!="string")return null
else{s=r[b]
return typeof s=="undefined"?this.me(b):s}},
gk(a){return this.b==null?this.c.a:this.cT().length},
gF(a){return this.gk(0)===0},
ga3(){if(this.b==null){var s=this.c
return new A.b5(s,A.p(s).h("b5<1>"))}return new A.k3(this)},
l(a,b,c){var s,r,q=this
if(q.b==null)q.c.l(0,b,c)
else if(q.E(b)){s=q.b
s[b]=c
r=q.a
if(r==null?s!=null:r!==s)r[b]=null}else q.mM().l(0,b,c)},
E(a){if(this.b==null)return this.c.E(a)
if(typeof a!="string")return!1
return Object.prototype.hasOwnProperty.call(this.a,a)},
ad(a,b){var s,r,q,p,o=this
if(o.b==null)return o.c.ad(0,b)
s=o.cT()
for(r=0;r<s.length;++r){q=s[r]
p=o.b[q]
if(typeof p=="undefined"){p=A.u7(o.a[q])
o.b[q]=p}b.$2(q,p)
if(s!==o.c)throw A.a(A.ao(o))}},
cT(){var s=this.c
if(s==null)s=this.c=A.u(Object.keys(this.a),t.s)
return s},
mM(){var s,r,q,p,o,n=this
if(n.b==null)return n.c
s=A.T(t.N,t.z)
r=n.cT()
for(q=0;p=r.length,q<p;++q){o=r[q]
s.l(0,o,n.i(0,o))}if(p===0)r.push("")
else B.c.au(r)
n.a=n.b=null
return n.c=s},
me(a){var s
if(!Object.prototype.hasOwnProperty.call(this.a,a))return null
s=A.u7(this.a[a])
return this.b[a]=s}}
A.k3.prototype={
gk(a){return this.a.gk(0)},
V(a,b){var s=this.a
return s.b==null?s.ga3().V(0,b):s.cT()[b]},
gA(a){var s=this.a
if(s.b==null){s=s.ga3()
s=s.gA(s)}else{s=s.cT()
s=new J.dF(s,s.length,A.a5(s).h("dF<1>"))}return s},
U(a,b){return this.a.E(b)}}
A.t0.prototype={
n(){var s,r,q=this
q.kW()
s=q.a
r=s.a
s.a=""
s=q.c.a
s.N(A.yA(r.charCodeAt(0)==0?r:r,q.b))
s.Z()}}
A.tL.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:53}
A.tK.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:53}
A.hT.prototype={
gbK(){return"us-ascii"},
b8(a){return B.aK.av(a)},
aI(a){var s=B.a1.av(a)
return s},
gdc(){return B.a1}}
A.kz.prototype={
av(a){var s,r,q,p=A.aJ(0,null,a.length),o=new Uint8Array(p)
for(s=~this.a,r=0;r<p;++r){q=a.charCodeAt(r)
if((q&s)!==0)throw A.a(A.b_(a,"string","Contains invalid characters."))
o[r]=q}return o},
bc(a){return new A.tD(new A.jN(a),this.a)}}
A.hV.prototype={}
A.tD.prototype={
n(){this.a.a.a.Z()},
ae(a,b,c,d){var s,r,q,p,o
A.aJ(b,c,a.length)
for(s=~this.b,r=b;r<c;++r){q=a.charCodeAt(r)
if((q&s)!==0)throw A.a(A.J("Source contains invalid character with code point: "+q+".",null))}s=new A.br(a)
p=s.gk(0)
A.aJ(b,c,p)
s=A.ap(s.kv(s,b,c),t.V.h("y.E"))
o=this.a.a.a
o.N(s)
if(d)o.Z()}}
A.ky.prototype={
av(a){var s,r,q,p=A.aJ(0,null,a.length)
for(s=~this.b,r=0;r<p;++r){q=a[r]
if((q&s)!==0){if(!this.a)throw A.a(A.ak("Invalid value in input: "+q,null,null))
return this.lt(a,0,p)}}return A.bJ(a,0,p)},
lt(a,b,c){var s,r,q,p
for(s=~this.b,r=b,q="";r<c;++r){p=a[r]
q+=A.aR((p&s)!==0?65533:p)}return q.charCodeAt(0)==0?q:q},
bj(a){return this.hy(a)}}
A.hU.prototype={
bc(a){var s=new A.dt(a)
if(this.a)return new A.rt(new A.kC(new A.cF(!1),s,new A.a0("")))
else return new A.ti(s)}}
A.rt.prototype={
n(){this.a.n()},
q(a,b){this.ae(b,0,J.aN(b),!1)},
ae(a,b,c,d){var s,r,q=J.ab(a)
A.aJ(b,c,q.gk(a))
for(s=this.a,r=b;r<c;++r)if((q.i(a,r)&4294967168)>>>0!==0){if(r>b)s.ae(a,b,r,!1)
s.ae(B.br,0,3,!1)
b=r+1}if(b<c)s.ae(a,b,c,!1)}}
A.ti.prototype={
n(){this.a.a.a.Z()},
q(a,b){var s,r
for(s=J.ab(b),r=0;r<s.gk(b);++r)if((s.i(b,r)&4294967168)>>>0!==0)throw A.a(A.ak("Source contains non-ASCII bytes.",null,null))
this.a.a.a.N(A.bJ(b,0,null))}}
A.lg.prototype={
oE(a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a="Invalid base64 encoding length "
a2=A.aJ(a1,a2,a0.length)
s=$.zy()
for(r=a1,q=r,p=null,o=-1,n=-1,m=0;r<a2;r=l){l=r+1
k=a0.charCodeAt(r)
if(k===37){j=l+2
if(j<=a2){i=A.uM(a0.charCodeAt(l))
h=A.uM(a0.charCodeAt(l+1))
g=i*16+h-(h&256)
if(g===37)g=-1
l=j}else g=-1}else g=k
if(0<=g&&g<=127){f=s[g]
if(f>=0){g=u.U.charCodeAt(f)
if(g===k)continue
k=g}else{if(f===-1){if(o<0){e=p==null?null:p.a.length
if(e==null)e=0
o=e+(r-q)
n=r}++m
if(k===61)continue}k=g}if(f!==-2){if(p==null){p=new A.a0("")
e=p}else e=p
e.a+=B.a.t(a0,q,r)
d=A.aR(k)
e.a+=d
q=l
continue}}throw A.a(A.ak("Invalid base64 data",a0,r))}if(p!=null){e=B.a.t(a0,q,a2)
e=p.a+=e
d=e.length
if(o>=0)A.wC(a0,n,a2,o,m,d)
else{c=B.b.aT(d-1,4)+1
if(c===1)throw A.a(A.ak(a,a0,a2))
while(c<4){e+="="
p.a=e;++c}}e=p.a
return B.a.c9(a0,a1,a2,e.charCodeAt(0)==0?e:e)}b=a2-a1
if(o>=0)A.wC(a0,n,a2,o,m,b)
else{c=B.b.aT(b,4)
if(c===1)throw A.a(A.ak(a,a0,a2))
if(c>1)a0=B.a.c9(a0,a2,a2,c===2?"==":"=")}return a0}}
A.hZ.prototype={
bc(a){return new A.qD(a,new A.qV(u.U))}}
A.qO.prototype={
ja(a){return new Uint8Array(a)},
nI(a,b,c,d){var s,r=this,q=(r.a&3)+(c-b),p=B.b.Y(q,3),o=p*4
if(d&&q-p*3>0)o+=4
s=r.ja(o)
r.a=A.BR(r.b,a,b,c,d,s,0,r.a)
if(o>0)return s
return null}}
A.qV.prototype={
ja(a){var s=this.c
if(s==null||s.length<a)s=this.c=new Uint8Array(a)
return J.cM(B.f.gar(s),s.byteOffset,a)}}
A.qP.prototype={
q(a,b){this.hT(b,0,J.aN(b),!1)},
n(){this.hT(B.bw,0,0,!0)}}
A.qD.prototype={
hT(a,b,c,d){var s=this.b.nI(a,b,c,d)
if(s!=null)this.a.a.N(A.bJ(s,0,null))
if(d)this.a.a.Z()}}
A.lx.prototype={}
A.jN.prototype={
q(a,b){this.a.a.N(b)},
n(){this.a.a.Z()}}
A.jO.prototype={
q(a,b){var s,r,q=this,p=q.b,o=q.c,n=J.ab(b)
if(n.gk(b)>p.length-o){p=q.b
s=n.gk(b)+p.length-1
s|=B.b.a2(s,1)
s|=s>>>2
s|=s>>>4
s|=s>>>8
r=new Uint8Array((((s|s>>>16)>>>0)+1)*2)
p=q.b
B.f.af(r,0,p.length,p)
q.b=r}p=q.b
o=q.c
B.f.af(p,o,o+n.gk(b),b)
q.c=q.c+n.gk(b)},
n(){this.a.$1(B.f.bS(this.b,0,this.c))}}
A.i9.prototype={}
A.dm.prototype={
q(a,b){this.b.q(0,b)},
ag(a,b){A.bd(a,"error",t.K)
this.a.ag(a,b)},
n(){this.b.n()},
$iaj:1}
A.ia.prototype={}
A.ah.prototype={
bc(a){throw A.a(A.P("This converter does not support chunked conversions: "+this.j(0)))},
bj(a){return new A.c8(new A.m3(this),a,t.fM.I(A.p(this).h("ah.T")).h("c8<1,2>"))}}
A.m3.prototype={
$1(a){return new A.dm(a,this.a.bc(a))},
$S:156}
A.cY.prototype={
ng(a){return this.gdc().bj(a).nX(0,new A.a0(""),new A.mT(),t.of).aK(new A.mU(),t.N)}}
A.mT.prototype={
$2(a,b){a.a+=b
return a},
$S:148}
A.mU.prototype={
$1(a){var s=a.a
return s.charCodeAt(0)==0?s:s},
$S:146}
A.fo.prototype={
j(a){var s=A.ik(this.a)
return(this.b!=null?"Converting object to an encodable object failed:":"Converting object did not return an encodable object:")+" "+s}}
A.iC.prototype={
j(a){return"Cyclic error in JSON stringify"}}
A.nK.prototype={
c5(a,b){var s=A.yA(a,this.gdc().a)
return s},
aI(a){return this.c5(a,null)},
fR(a,b){var s=A.Cc(a,this.gnJ().b,null)
return s},
b8(a){return this.fR(a,null)},
gnJ(){return B.bo},
gdc(){return B.bn}}
A.iE.prototype={
bc(a){return new A.t1(null,this.b,new A.dt(a))}}
A.t1.prototype={
q(a,b){var s,r,q,p=this
if(p.d)throw A.a(A.z("Only one call to add allowed"))
p.d=!0
s=p.c
r=new A.a0("")
q=new A.tw(r,s)
A.xW(b,q,p.b,p.a)
if(r.a.length!==0)q.fa()
s.n()},
n(){}}
A.iD.prototype={
bc(a){return new A.t0(this.a,a,new A.a0(""))}}
A.t3.prototype={
jW(a){var s,r,q,p,o,n=this,m=a.length
for(s=0,r=0;r<m;++r){q=a.charCodeAt(r)
if(q>92){if(q>=55296){p=q&64512
if(p===55296){o=r+1
o=!(o<m&&(a.charCodeAt(o)&64512)===56320)}else o=!1
if(!o)if(p===56320){p=r-1
p=!(p>=0&&(a.charCodeAt(p)&64512)===55296)}else p=!1
else p=!0
if(p){if(r>s)n.eG(a,s,r)
s=r+1
n.a5(92)
n.a5(117)
n.a5(100)
p=q>>>8&15
n.a5(p<10?48+p:87+p)
p=q>>>4&15
n.a5(p<10?48+p:87+p)
p=q&15
n.a5(p<10?48+p:87+p)}}continue}if(q<32){if(r>s)n.eG(a,s,r)
s=r+1
n.a5(92)
switch(q){case 8:n.a5(98)
break
case 9:n.a5(116)
break
case 10:n.a5(110)
break
case 12:n.a5(102)
break
case 13:n.a5(114)
break
default:n.a5(117)
n.a5(48)
n.a5(48)
p=q>>>4&15
n.a5(p<10?48+p:87+p)
p=q&15
n.a5(p<10?48+p:87+p)
break}}else if(q===34||q===92){if(r>s)n.eG(a,s,r)
s=r+1
n.a5(92)
n.a5(q)}}if(s===0)n.aB(a)
else if(s<m)n.eG(a,s,m)},
eY(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<r;++q){p=s[q]
if(a==null?p==null:a===p)throw A.a(new A.iC(a,null))}s.push(a)},
eF(a){var s,r,q,p,o=this
if(o.jV(a))return
o.eY(a)
try{s=o.b.$1(a)
if(!o.jV(s)){q=A.x0(a,null,o.gio())
throw A.a(q)}o.a.pop()}catch(p){r=A.E(p)
q=A.x0(a,r,o.gio())
throw A.a(q)}},
jV(a){var s,r=this
if(typeof a=="number"){if(!isFinite(a))return!1
r.ph(a)
return!0}else if(a===!0){r.aB("true")
return!0}else if(a===!1){r.aB("false")
return!0}else if(a==null){r.aB("null")
return!0}else if(typeof a=="string"){r.aB('"')
r.jW(a)
r.aB('"')
return!0}else if(t.j.b(a)){r.eY(a)
r.pf(a)
r.a.pop()
return!0}else if(t.av.b(a)){r.eY(a)
s=r.pg(a)
r.a.pop()
return s}else return!1},
pf(a){var s,r,q=this
q.aB("[")
s=J.ab(a)
if(s.gaP(a)){q.eF(s.i(a,0))
for(r=1;r<s.gk(a);++r){q.aB(",")
q.eF(s.i(a,r))}}q.aB("]")},
pg(a){var s,r,q,p,o=this,n={}
if(a.gF(a)){o.aB("{}")
return!0}s=a.gk(a)*2
r=A.b7(s,null,!1,t.X)
q=n.a=0
n.b=!0
a.ad(0,new A.t4(n,r))
if(!n.b)return!1
o.aB("{")
for(p='"';q<s;q+=2,p=',"'){o.aB(p)
o.jW(A.al(r[q]))
o.aB('":')
o.eF(r[q+1])}o.aB("}")
return!0}}
A.t4.prototype={
$2(a,b){var s,r,q,p
if(typeof a!="string")this.a.b=!1
s=this.b
r=this.a
q=r.a
p=r.a=q+1
s[q]=a
r.a=p+1
s[p]=b},
$S:54}
A.t2.prototype={
gio(){var s=this.c
return s instanceof A.a0?s.j(0):null},
ph(a){this.c.eE(B.ac.j(a))},
aB(a){this.c.eE(a)},
eG(a,b,c){this.c.eE(B.a.t(a,b,c))},
a5(a){this.c.a5(a)}}
A.iF.prototype={
gbK(){return"iso-8859-1"},
b8(a){return B.bp.av(a)},
aI(a){var s=B.ad.av(a)
return s},
gdc(){return B.ad}}
A.iH.prototype={}
A.iG.prototype={
bc(a){var s=new A.dt(a)
if(!this.a)return new A.k4(s)
return new A.t5(s)}}
A.k4.prototype={
n(){this.a.a.a.Z()
this.a=null},
q(a,b){this.ae(b,0,J.aN(b),!1)},
hG(a,b,c,d){var s=this.a
s.toString
s.a.a.N(A.bJ(a,b,c))},
ae(a,b,c,d){A.aJ(b,c,J.aN(a))
if(b===c)return
if(!t.p.b(a))A.Cd(a,b,c)
this.hG(a,b,c,!1)}}
A.t5.prototype={
ae(a,b,c,d){var s,r,q,p,o="Stream is already closed",n=J.ab(a)
A.aJ(b,c,n.gk(a))
for(s=b;s<c;++s){r=n.i(a,s)
if(r>255||r<0){if(s>b){q=this.a
q.toString
p=A.bJ(a,b,s)
q=q.a.a
if((q.e&2)!==0)A.r(A.z(o))
q.bT(p)}q=this.a
q.toString
p=A.bJ(B.bs,0,1)
q=q.a.a
if((q.e&2)!==0)A.r(A.z(o))
q.bT(p)
b=s+1}}if(b<c)this.hG(a,b,c,!1)}}
A.nL.prototype={
bj(a){return new A.c8(A.Eh(),a,t.it)}}
A.t6.prototype={
ae(a,b,c,d){var s=this
c=A.aJ(b,c,a.length)
if(b<c){if(s.d){if(a.charCodeAt(b)===10)++b
s.d=!1}s.lg(a,b,c,d)}if(d)s.n()},
n(){var s=this,r=s.b
if(r!=null)s.a.a.a.N(s.fD(r,""))
s.a.a.a.Z()},
lg(a,b,c,d){var s,r,q,p,o,n,m,l,k=this,j=k.b
for(s=k.a.a.a,r=b,q=r,p=0;r<c;++r,p=o){o=a.charCodeAt(r)
if(o!==13){if(o!==10)continue
if(p===13){q=r+1
continue}}n=B.a.t(a,q,r)
if(j!=null){n=k.fD(j,n)
j=null}if((s.e&2)!==0)A.r(A.z("Stream is already closed"))
s.bT(n)
q=r+1}if(q<c){m=B.a.t(a,q,c)
if(d){s.N(j!=null?k.fD(j,m):m)
return}if(j==null)k.b=m
else{l=k.c
if(l==null)l=k.c=new A.a0("")
if(j.length!==0){l.a+=j
k.b=""}l.a+=m}}else k.d=p===13},
fD(a,b){var s,r
this.b=null
if(a.length!==0)return a+b
s=this.c
r=s.a+=b
s.a=""
return r.charCodeAt(0)==0?r:r}}
A.eu.prototype={
ag(a,b){this.e.ag(a,b)},
$iaj:1}
A.jm.prototype={
q(a,b){this.ae(b,0,b.length,!1)}}
A.tw.prototype={
a5(a){var s=this.a,r=A.aR(a)
if((s.a+=r).length>16)this.fa()},
eE(a){if(this.a.a.length!==0)this.fa()
this.b.q(0,a)},
fa(){var s=this.a,r=s.a
s.a=""
this.b.q(0,r.charCodeAt(0)==0?r:r)}}
A.hw.prototype={
n(){},
ae(a,b,c,d){var s,r,q
if(b!==0||c!==a.length)for(s=this.a,r=b;r<c;++r){q=A.aR(a.charCodeAt(r))
s.a+=q}else this.a.a+=a
if(d)this.n()},
q(a,b){this.a.a+=b}}
A.dt.prototype={
q(a,b){this.a.a.N(b)},
ae(a,b,c,d){var s=b===0&&c===a.length,r=this.a.a
if(s)r.N(a)
else r.N(B.a.t(a,b,c))
if(d)r.Z()},
n(){this.a.a.Z()}}
A.kC.prototype={
n(){var s,r,q,p=this.c
this.a.nW(p)
s=p.a
r=this.b
if(s.length!==0){q=s.charCodeAt(0)==0?s:s
p.a=""
r.ae(q,0,q.length,!0)}else r.n()},
q(a,b){this.ae(b,0,J.aN(b),!1)},
ae(a,b,c,d){var s,r=this,q=r.c,p=r.a.cU(a,b,c,!1)
p=q.a+=p
if(p.length!==0){s=p.charCodeAt(0)==0?p:p
r.b.ae(s,0,s.length,d)
q.a=""
return}if(d)r.n()}}
A.jx.prototype={
gbK(){return"utf-8"},
aI(a){return new A.cF(!1).cU(a,0,null,!0)},
b8(a){return B.o.av(a)},
gdc(){return B.aF}}
A.jz.prototype={
av(a){var s,r,q=A.aJ(0,null,a.length)
if(q===0)return new Uint8Array(0)
s=new Uint8Array(q*3)
r=new A.kD(s)
if(r.i3(a,0,q)!==q)r.e1()
return B.f.bS(s,0,r.b)},
bc(a){return new A.tM(new A.jN(a),new Uint8Array(1024))}}
A.kD.prototype={
e1(){var s=this,r=s.c,q=s.b,p=s.b=q+1
r.$flags&2&&A.C(r)
r[q]=239
q=s.b=p+1
r[p]=191
s.b=q+1
r[q]=189},
iX(a,b){var s,r,q,p,o=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=o.c
q=o.b
p=o.b=q+1
r.$flags&2&&A.C(r)
r[q]=s>>>18|240
q=o.b=p+1
r[p]=s>>>12&63|128
p=o.b=q+1
r[q]=s>>>6&63|128
o.b=p+1
r[p]=s&63|128
return!0}else{o.e1()
return!1}},
i3(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c&&(a.charCodeAt(c-1)&64512)===55296)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=b;p<c;++p){o=a.charCodeAt(p)
if(o<=127){n=k.b
if(n>=q)break
k.b=n+1
r&2&&A.C(s)
s[n]=o}else{n=o&64512
if(n===55296){if(k.b+4>q)break
m=p+1
if(k.iX(o,a.charCodeAt(m)))p=m}else if(n===56320){if(k.b+3>q)break
k.e1()}else if(o<=2047){n=k.b
l=n+1
if(l>=q)break
k.b=l
r&2&&A.C(s)
s[n]=o>>>6|192
k.b=l+1
s[l]=o&63|128}else{n=k.b
if(n+2>=q)break
l=k.b=n+1
r&2&&A.C(s)
s[n]=o>>>12|224
n=k.b=l+1
s[l]=o>>>6&63|128
k.b=n+1
s[n]=o&63|128}}}return p}}
A.tM.prototype={
n(){if(this.a!==0){this.ae("",0,0,!0)
return}this.d.a.a.Z()},
ae(a,b,c,d){var s,r,q,p,o,n=this
n.b=0
s=b===c
if(s&&!d)return
r=n.a
if(r!==0){if(n.iX(r,!s?a.charCodeAt(b):0))++b
n.a=0}s=n.d
r=n.c
q=c-1
p=r.length-3
do{b=n.i3(a,b,c)
o=d&&b===c
if(b===q&&(a.charCodeAt(b)&64512)===55296){if(d&&n.b<p)n.e1()
else n.a=a.charCodeAt(b);++b}s.q(0,B.f.bS(r,0,n.b))
if(o)s.n()
n.b=0}while(b<c)
if(d)n.n()}}
A.jy.prototype={
bc(a){return new A.kC(new A.cF(this.a),new A.dt(a),new A.a0(""))},
bj(a){return this.hy(a)}}
A.cF.prototype={
cU(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.aJ(b,c,J.aN(a))
if(b===l)return""
if(a instanceof Uint8Array){s=a
r=s
q=0}else{r=A.CM(a,b,l)
l-=b
q=b
b=0}if(d&&l-b>=15){p=m.a
o=A.CL(p,r,b,l)
if(o!=null){if(!p)return o
if(o.indexOf("\ufffd")<0)return o}}o=m.f7(r,b,l,d)
p=m.b
if((p&1)!==0){n=A.yj(p)
m.b=0
throw A.a(A.ak(n,a,q+m.c))}return o},
f7(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.b.Y(b+c,2)
r=q.f7(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.f7(a,s,c,d)}return q.nf(a,b,c,d)},
nW(a){var s,r=this.b
this.b=0
if(r<=32)return
if(this.a){s=A.aR(65533)
a.a+=s}else throw A.a(A.ak(A.yj(77),null,null))},
nf(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.a0(""),g=b+1,f=a[b]
A:for(s=l.a;;){for(;;g=p){r="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE".charCodeAt(f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA".charCodeAt(j+r)
if(j===0){q=A.aR(i)
h.a+=q
if(g===c)break A
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:q=A.aR(k)
h.a+=q
break
case 65:q=A.aR(k)
h.a+=q;--g
break
default:q=A.aR(k)
h.a=(h.a+=q)+q
break}else{l.b=j
l.c=g-1
return""}j=0}if(g===c)break A
p=g+1
f=a[g]}p=g+1
f=a[g]
if(f<128){for(;;){if(!(p<c)){o=c
break}n=p+1
f=a[p]
if(f>=128){o=n-1
p=n
break}p=n}if(o-g<20)for(m=g;m<o;++m){q=A.aR(a[m])
h.a+=q}else{q=A.bJ(a,g,o)
h.a+=q}if(o===c)break A
g=p}else g=p}if(d&&j>32)if(s){s=A.aR(k)
h.a+=s}else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.kI.prototype={}
A.aA.prototype={
bz(a){var s,r,q=this,p=q.c
if(p===0)return q
s=!q.a
r=q.b
p=A.bi(p,r)
return new A.aA(p===0?!1:s,r,p)},
ly(a){var s,r,q,p,o,n,m,l=this,k=l.c
if(k===0)return $.ch()
s=k-a
if(s<=0)return l.a?$.wu():$.ch()
r=l.b
q=new Uint16Array(s)
for(p=a;p<k;++p)q[p-a]=r[p]
o=l.a
n=A.bi(s,q)
m=new A.aA(n===0?!1:o,q,n)
if(o)for(p=0;p<a;++p)if(r[p]!==0)return m.eQ(0,$.kX())
return m},
cO(a,b){var s,r,q,p,o,n,m,l,k,j=this
if(b<0)throw A.a(A.J("shift-amount must be posititve "+b,null))
s=j.c
if(s===0)return j
r=B.b.Y(b,16)
q=B.b.aT(b,16)
if(q===0)return j.ly(r)
p=s-r
if(p<=0)return j.a?$.wu():$.ch()
o=j.b
n=new Uint16Array(p)
A.BX(o,s,b,n)
s=j.a
m=A.bi(p,n)
l=new A.aA(m===0?!1:s,n,m)
if(s){if((o[r]&B.b.cN(1,q)-1)>>>0!==0)return l.eQ(0,$.kX())
for(k=0;k<r;++k)if(o[k]!==0)return l.eQ(0,$.kX())}return l},
a_(a,b){var s,r=this.a
if(r===b.a){s=A.qR(this.b,this.c,b.b,b.c)
return r?0-s:s}return r?-1:1},
eT(a,b){var s,r,q,p=this,o=p.c,n=a.c
if(o<n)return a.eT(p,b)
if(o===0)return $.ch()
if(n===0)return p.a===b?p:p.bz(0)
s=o+1
r=new Uint16Array(s)
A.BS(p.b,o,a.b,n,r)
q=A.bi(s,r)
return new A.aA(q===0?!1:b,r,q)},
dM(a,b){var s,r,q,p=this,o=p.c
if(o===0)return $.ch()
s=a.c
if(s===0)return p.a===b?p:p.bz(0)
r=new Uint16Array(o)
A.jK(p.b,o,a.b,s,r)
q=A.bi(o,r)
return new A.aA(q===0?!1:b,r,q)},
dF(a,b){var s,r,q=this,p=q.c
if(p===0)return b
s=b.c
if(s===0)return q
r=q.a
if(r===b.a)return q.eT(b,r)
if(A.qR(q.b,p,b.b,s)>=0)return q.dM(b,r)
return b.dM(q,!r)},
eQ(a,b){var s,r,q=this,p=q.c
if(p===0)return b.bz(0)
s=b.c
if(s===0)return q
r=q.a
if(r!==b.a)return q.eT(b,r)
if(A.qR(q.b,p,b.b,s)>=0)return q.dM(b,r)
return b.dM(q,!r)},
aL(a,b){var s,r,q,p,o,n,m,l=this.c,k=b.c
if(l===0||k===0)return $.ch()
s=l+k
r=this.b
q=b.b
p=new Uint16Array(s)
for(o=0;o<k;){A.xN(q[o],r,0,p,o,l);++o}n=this.a!==b.a
m=A.bi(s,p)
return new A.aA(m===0?!1:n,p,m)},
lw(a){var s,r,q,p
if(this.c<a.c)return $.ch()
this.hZ(a)
s=$.vP.aV()-$.h2.aV()
r=A.vR($.vO.aV(),$.h2.aV(),$.vP.aV(),s)
q=A.bi(s,r)
p=new A.aA(!1,r,q)
return this.a!==a.a&&q>0?p.bz(0):p},
ml(a){var s,r,q,p=this
if(p.c<a.c)return p
p.hZ(a)
s=A.vR($.vO.aV(),0,$.h2.aV(),$.h2.aV())
r=A.bi($.h2.aV(),s)
q=new A.aA(!1,s,r)
if($.vQ.aV()>0)q=q.cO(0,$.vQ.aV())
return p.a&&q.c>0?q.bz(0):q},
hZ(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=c.c
if(b===$.xK&&a.c===$.xM&&c.b===$.xJ&&a.b===$.xL)return
s=a.b
r=a.c
q=16-B.b.gj4(s[r-1])
if(q>0){p=new Uint16Array(r+5)
o=A.xI(s,r,q,p)
n=new Uint16Array(b+5)
m=A.xI(c.b,b,q,n)}else{n=A.vR(c.b,0,b,b+2)
o=r
p=s
m=b}l=p[o-1]
k=m-o
j=new Uint16Array(m)
i=A.vS(p,o,k,j)
h=m+1
g=n.$flags|0
if(A.qR(n,m,j,i)>=0){g&2&&A.C(n)
n[m]=1
A.jK(n,h,j,i,n)}else{g&2&&A.C(n)
n[m]=0}f=new Uint16Array(o+2)
f[o]=1
A.jK(f,o+1,p,o,f)
e=m-1
while(k>0){d=A.BT(l,n,e);--k
A.xN(d,f,0,n,k,o)
if(n[e]<d){i=A.vS(f,o,k,j)
A.jK(n,h,j,i,n)
while(--d,n[e]<d)A.jK(n,h,j,i,n)}--e}$.xJ=c.b
$.xK=b
$.xL=s
$.xM=r
$.vO.b=n
$.vP.b=h
$.h2.b=o
$.vQ.b=q},
gv(a){var s,r,q,p=new A.qS(),o=this.c
if(o===0)return 6707
s=this.a?83585:429689
for(r=this.b,q=0;q<o;++q)s=p.$2(s,r[q])
return new A.qT().$1(s)},
D(a,b){if(b==null)return!1
return b instanceof A.aA&&this.a_(0,b)===0},
j(a){var s,r,q,p,o,n=this,m=n.c
if(m===0)return"0"
if(m===1){if(n.a)return B.b.j(-n.b[0])
return B.b.j(n.b[0])}s=A.u([],t.s)
m=n.a
r=m?n.bz(0):n
while(r.c>1){q=$.wt()
if(q.c===0)A.r(B.aR)
p=r.ml(q).j(0)
s.push(p)
o=p.length
if(o===1)s.push("000")
if(o===2)s.push("00")
if(o===3)s.push("0")
r=r.lw(q)}s.push(B.b.j(r.b[0]))
if(m)s.push("-")
return new A.d8(s,t.hF).oo(0)},
$ia7:1}
A.qS.prototype={
$2(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
$S:145}
A.qT.prototype={
$1(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
$S:143}
A.jW.prototype={
j1(a,b,c){var s=this.a
if(s!=null)s.register(a,b,c)},
jf(a){var s=this.a
if(s!=null)s.unregister(a)}}
A.bT.prototype={
D(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.bT)if(this.a===b.a)s=this.b===b.b
return s},
gv(a){return A.c0(this.a,this.b,B.e,B.e,B.e,B.e)},
a_(a,b){var s=B.b.a_(this.a,b.a)
if(s!==0)return s
return B.b.a_(this.b,b.b)},
j(a){var s=this,r=A.Aq(A.xj(s)),q=A.ih(A.xh(s)),p=A.ih(A.xe(s)),o=A.ih(A.xf(s)),n=A.ih(A.xg(s)),m=A.ih(A.xi(s)),l=A.wO(A.B5(s)),k=s.b,j=k===0?"":A.wO(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j},
$ia7:1}
A.b1.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.b1&&this.a===b.a},
gv(a){return B.b.gv(this.a)},
a_(a,b){return B.b.a_(this.a,b.a)},
j(a){var s,r,q,p,o,n=this.a,m=B.b.Y(n,36e8),l=n%36e8
if(n<0){m=0-m
n=0-l
s="-"}else{n=l
s=""}r=B.b.Y(n,6e7)
n%=6e7
q=r<10?"0":""
p=B.b.Y(n,1e6)
o=p<10?"0":""
return s+m+":"+q+r+":"+o+p+"."+B.a.oK(B.b.j(n%1e6),6,"0")},
$ia7:1}
A.rr.prototype={
j(a){return this.aF()}}
A.W.prototype={
gbA(){return A.B4(this)}}
A.hW.prototype={
j(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.ik(s)
return"Assertion failed"}}
A.c4.prototype={}
A.a3.prototype={
gf9(){return"Invalid argument"+(!this.a?"(s)":"")},
gf8(){return""},
j(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.q(p),n=s.gf9()+q+o
if(!s.a)return n
return n+s.gf8()+": "+A.ik(s.gh2())},
gh2(){return this.b}}
A.e1.prototype={
gh2(){return this.b},
gf9(){return"RangeError"},
gf8(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.q(q):""
else if(q==null)s=": Not greater than or equal to "+A.q(r)
else if(q>r)s=": Not in inclusive range "+A.q(r)+".."+A.q(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.q(r)
return s}}
A.fj.prototype={
gh2(){return this.b},
gf9(){return"RangeError"},
gf8(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gk(a){return this.f}}
A.fR.prototype={
j(a){return"Unsupported operation: "+this.a}}
A.jp.prototype={
j(a){var s=this.a
return s!=null?"UnimplementedError: "+s:"UnimplementedError"}}
A.aX.prototype={
j(a){return"Bad state: "+this.a}}
A.ib.prototype={
j(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.ik(s)+"."}}
A.iV.prototype={
j(a){return"Out of Memory"},
gbA(){return null},
$iW:1}
A.fG.prototype={
j(a){return"Stack Overflow"},
gbA(){return null},
$iW:1}
A.jV.prototype={
j(a){return"Exception: "+this.a},
$iO:1}
A.aU.prototype={
j(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.a.t(e,0,75)+"..."
return g+"\n"+e}for(r=1,q=0,p=!1,o=0;o<f;++o){n=e.charCodeAt(o)
if(n===10){if(q!==o||!p)++r
q=o+1
p=!1}else if(n===13){++r
q=o+1
p=!0}}g=r>1?g+(" (at line "+r+", character "+(f-q+1)+")\n"):g+(" (at character "+(f+1)+")\n")
m=e.length
for(o=f;o<m;++o){n=e.charCodeAt(o)
if(n===10||n===13){m=o
break}}l=""
if(m-q>78){k="..."
if(f-q<75){j=q+75
i=q}else{if(m-f<75){i=m-75
j=m
k=""}else{i=f-36
j=f+36}l="..."}}else{j=m
i=q
k=""}return g+l+B.a.t(e,i,j)+k+"\n"+B.a.aL(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.q(f)+")"):g},
$iO:1,
gjC(){return this.a},
gdK(){return this.b},
ga8(){return this.c}}
A.iw.prototype={
gbA(){return null},
j(a){return"IntegerDivisionByZeroException"},
$iW:1,
$iO:1}
A.n.prototype={
ea(a,b){return A.i6(this,A.p(this).h("n.E"),b)},
b9(a,b,c){return A.nU(this,b,A.p(this).h("n.E"),c)},
U(a,b){var s
for(s=this.gA(this);s.m();)if(J.A(s.gp(),b))return!0
return!1},
cb(a,b){var s=A.p(this).h("n.E")
if(b)s=A.ap(this,s)
else{s=A.ap(this,s)
s.$flags=1
s=s}return s},
jS(a){return this.cb(0,!0)},
gk(a){var s,r=this.gA(this)
for(s=0;r.m();)++s
return s},
gF(a){return!this.gA(this).m()},
gaP(a){return!this.gF(this)},
bO(a,b){return A.xy(this,b,A.p(this).h("n.E"))},
aU(a,b){return A.xr(this,b,A.p(this).h("n.E"))},
gai(a){var s=this.gA(this)
if(!s.m())throw A.a(A.bW())
return s.gp()},
V(a,b){var s,r
A.aI(b,"index")
s=this.gA(this)
for(r=b;s.m();){if(r===0)return s.gp();--r}throw A.a(A.iu(b,b-r,this,null,"index"))},
j(a){return A.AJ(this,"(",")")}}
A.M.prototype={
j(a){return"MapEntry("+A.q(this.a)+": "+A.q(this.b)+")"}}
A.F.prototype={
gv(a){return A.k.prototype.gv.call(this,0)},
j(a){return"null"}}
A.k.prototype={$ik:1,
D(a,b){return this===b},
gv(a){return A.e0(this)},
j(a){return"Instance of '"+A.j_(this)+"'"},
ga4(a){return A.uL(this)},
toString(){return this.j(this)}}
A.ku.prototype={
j(a){return""},
$iad:1}
A.a0.prototype={
gk(a){return this.a.length},
eE(a){var s=A.q(a)
this.a+=s},
a5(a){var s=A.aR(a)
this.a+=s},
j(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.pO.prototype={
$2(a,b){throw A.a(A.ak("Illegal IPv6 address, "+a,this.a,b))},
$S:92}
A.hD.prototype={
giM(){var s,r,q,p,o=this,n=o.w
if(n===$){s=o.a
r=s.length!==0?s+":":""
q=o.c
p=q==null
if(!p||s==="file"){s=r+"//"
r=o.b
if(r.length!==0)s=s+r+"@"
if(!p)s+=q
r=o.d
if(r!=null)s=s+":"+A.q(r)}else s=r
s+=o.e
r=o.f
if(r!=null)s=s+"?"+r
r=o.r
if(r!=null)s=s+"#"+r
n=o.w=s.charCodeAt(0)==0?s:s}return n},
goM(){var s,r,q=this,p=q.x
if(p===$){s=q.e
if(s.length!==0&&s.charCodeAt(0)===47)s=B.a.a0(s,1)
r=s.length===0?B.J:A.nP(new A.a8(A.u(s.split("/"),t.s),A.Ej(),t.iZ),t.N)
q.x!==$&&A.wq()
p=q.x=r}return p},
gv(a){var s,r=this,q=r.y
if(q===$){s=B.a.gv(r.giM())
r.y!==$&&A.wq()
r.y=s
q=s}return q},
ghk(){return this.b},
gbH(){var s=this.c
if(s==null)return""
if(B.a.K(s,"[")&&!B.a.R(s,"v",1))return B.a.t(s,1,s.length-1)
return s},
gdt(){var s=this.d
return s==null?A.y7(this.a):s},
gdv(){var s=this.f
return s==null?"":s},
gei(){var s=this.r
return s==null?"":s},
el(a){var s=this.a
if(a.length!==s.length)return!1
return A.yp(a,s,0)>=0},
jQ(a){var s,r,q,p,o,n,m,l=this
a=A.w_(a,0,a.length)
s=a==="file"
r=l.b
q=l.d
if(a!==l.a)q=A.tJ(q,a)
p=l.c
if(!(p!=null))p=r.length!==0||q!=null||s?"":null
o=l.e
if(!s)n=p!=null&&o.length!==0
else n=!0
if(n&&!B.a.K(o,"/"))o="/"+o
m=o
return A.hE(a,r,p,q,m,l.f,l.r)},
ik(a,b){var s,r,q,p,o,n,m
for(s=0,r=0;B.a.R(b,"../",r);){r+=3;++s}q=B.a.cA(a,"/")
for(;;){if(!(q>0&&s>0))break
p=B.a.em(a,"/",q-1)
if(p<0)break
o=q-p
n=o!==2
m=!1
if(!n||o===3)if(a.charCodeAt(p+1)===46)n=!n||a.charCodeAt(p+2)===46
else n=m
else n=m
if(n)break;--s
q=p}return B.a.c9(a,q+1,null,B.a.a0(b,r-3*s))},
dz(a){return this.dA(A.dg(a))},
dA(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
if(a.gaD().length!==0)return a
else{s=h.a
if(a.gfX()){r=a.jQ(s)
return r}else{q=h.b
p=h.c
o=h.d
n=h.e
if(a.gjv())m=a.gek()?a.gdv():h.f
else{l=A.CK(h,n)
if(l>0){k=B.a.t(n,0,l)
n=a.gfW()?k+A.dw(a.gaR()):k+A.dw(h.ik(B.a.a0(n,k.length),a.gaR()))}else if(a.gfW())n=A.dw(a.gaR())
else if(n.length===0)if(p==null)n=s.length===0?a.gaR():A.dw(a.gaR())
else n=A.dw("/"+a.gaR())
else{j=h.ik(n,a.gaR())
r=s.length===0
if(!r||p!=null||B.a.K(n,"/"))n=A.dw(j)
else n=A.w1(j,!r||p!=null)}m=a.gek()?a.gdv():null}}}i=a.gfY()?a.gei():null
return A.hE(s,q,p,o,n,m,i)},
gfX(){return this.c!=null},
gek(){return this.f!=null},
gfY(){return this.r!=null},
gjv(){return this.e.length===0},
gfW(){return B.a.K(this.e,"/")},
hi(){var s,r=this,q=r.a
if(q!==""&&q!=="file")throw A.a(A.P("Cannot extract a file path from a "+q+" URI"))
q=r.f
if((q==null?"":q)!=="")throw A.a(A.P(u.z))
q=r.r
if((q==null?"":q)!=="")throw A.a(A.P(u.A))
if(r.c!=null&&r.gbH()!=="")A.r(A.P(u.Q))
s=r.goM()
A.CF(s,!1)
q=A.vE(B.a.K(r.e,"/")?"/":"",s,"/")
q=q.charCodeAt(0)==0?q:q
return q},
j(a){return this.giM()},
D(a,b){var s,r,q,p=this
if(b==null)return!1
if(p===b)return!0
s=!1
if(t.R.b(b))if(p.a===b.gaD())if(p.c!=null===b.gfX())if(p.b===b.ghk())if(p.gbH()===b.gbH())if(p.gdt()===b.gdt())if(p.e===b.gaR()){r=p.f
q=r==null
if(!q===b.gek()){if(q)r=""
if(r===b.gdv()){r=p.r
q=r==null
if(!q===b.gfY()){s=q?"":r
s=s===b.gei()}}}}return s},
$ijv:1,
gaD(){return this.a},
gaR(){return this.e}}
A.pN.prototype={
gjT(){var s,r,q,p,o=this,n=null,m=o.c
if(m==null){m=o.a
s=o.b[0]+1
r=B.a.bn(m,"?",s)
q=m.length
if(r>=0){p=A.hF(m,r+1,q,256,!1,!1)
q=r}else p=n
m=o.c=new A.jS("data","",n,n,A.hF(m,s,q,128,!1,!1),p,n)}return m},
j(a){var s=this.a
return this.b[0]===-1?"data:"+s:s}}
A.bk.prototype={
gfX(){return this.c>0},
gfZ(){return this.c>0&&this.d+1<this.e},
gek(){return this.f<this.r},
gfY(){return this.r<this.a.length},
gfW(){return B.a.R(this.a,"/",this.e)},
gjv(){return this.e===this.f},
el(a){var s=a.length
if(s===0)return this.b<0
if(s!==this.b)return!1
return A.yp(a,this.a,0)>=0},
gaD(){var s=this.w
return s==null?this.w=this.lr():s},
lr(){var s,r=this,q=r.b
if(q<=0)return""
s=q===4
if(s&&B.a.K(r.a,"http"))return"http"
if(q===5&&B.a.K(r.a,"https"))return"https"
if(s&&B.a.K(r.a,"file"))return"file"
if(q===7&&B.a.K(r.a,"package"))return"package"
return B.a.t(r.a,0,q)},
ghk(){var s=this.c,r=this.b+3
return s>r?B.a.t(this.a,r,s-1):""},
gbH(){var s=this.c
return s>0?B.a.t(this.a,s,this.d):""},
gdt(){var s,r=this
if(r.gfZ())return A.z_(B.a.t(r.a,r.d+1,r.e))
s=r.b
if(s===4&&B.a.K(r.a,"http"))return 80
if(s===5&&B.a.K(r.a,"https"))return 443
return 0},
gaR(){return B.a.t(this.a,this.e,this.f)},
gdv(){var s=this.f,r=this.r
return s<r?B.a.t(this.a,s+1,r):""},
gei(){var s=this.r,r=this.a
return s<r.length?B.a.a0(r,s+1):""},
ig(a){var s=this.d+1
return s+a.length===this.e&&B.a.R(this.a,a,s)},
oU(){var s=this,r=s.r,q=s.a
if(r>=q.length)return s
return new A.bk(B.a.t(q,0,r),s.b,s.c,s.d,s.e,s.f,r,s.w)},
jQ(a){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null
a=A.w_(a,0,a.length)
s=!(h.b===a.length&&B.a.K(h.a,a))
r=a==="file"
q=h.c
p=q>0?B.a.t(h.a,h.b+3,q):""
o=h.gfZ()?h.gdt():g
if(s)o=A.tJ(o,a)
q=h.c
if(q>0)n=B.a.t(h.a,q,h.d)
else n=p.length!==0||o!=null||r?"":g
q=h.a
m=h.f
l=B.a.t(q,h.e,m)
if(!r)k=n!=null&&l.length!==0
else k=!0
if(k&&!B.a.K(l,"/"))l="/"+l
k=h.r
j=m<k?B.a.t(q,m+1,k):g
m=h.r
i=m<q.length?B.a.a0(q,m+1):g
return A.hE(a,p,n,o,l,j,i)},
dz(a){return this.dA(A.dg(a))},
dA(a){if(a instanceof A.bk)return this.mC(this,a)
return this.iO().dA(a)},
mC(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=b.b
if(c>0)return b
s=b.c
if(s>0){r=a.b
if(r<=0)return b
q=r===4
if(q&&B.a.K(a.a,"file"))p=b.e!==b.f
else if(q&&B.a.K(a.a,"http"))p=!b.ig("80")
else p=!(r===5&&B.a.K(a.a,"https"))||!b.ig("443")
if(p){o=r+1
return new A.bk(B.a.t(a.a,0,o)+B.a.a0(b.a,c+1),r,s+o,b.d+o,b.e+o,b.f+o,b.r+o,a.w)}else return this.iO().dA(b)}n=b.e
c=b.f
if(n===c){s=b.r
if(c<s){r=a.f
o=r-c
return new A.bk(B.a.t(a.a,0,r)+B.a.a0(b.a,c),a.b,a.c,a.d,a.e,c+o,s+o,a.w)}c=b.a
if(s<c.length){r=a.r
return new A.bk(B.a.t(a.a,0,r)+B.a.a0(c,s),a.b,a.c,a.d,a.e,a.f,s+(r-s),a.w)}return a.oU()}s=b.a
if(B.a.R(s,"/",n)){m=a.e
l=A.y_(this)
k=l>0?l:m
o=k-n
return new A.bk(B.a.t(a.a,0,k)+B.a.a0(s,n),a.b,a.c,a.d,m,c+o,b.r+o,a.w)}j=a.e
i=a.f
if(j===i&&a.c>0){while(B.a.R(s,"../",n))n+=3
o=j-n+1
return new A.bk(B.a.t(a.a,0,j)+"/"+B.a.a0(s,n),a.b,a.c,a.d,j,c+o,b.r+o,a.w)}h=a.a
l=A.y_(this)
if(l>=0)g=l
else for(g=j;B.a.R(h,"../",g);)g+=3
f=0
for(;;){e=n+3
if(!(e<=c&&B.a.R(s,"../",n)))break;++f
n=e}for(d="";i>g;){--i
if(h.charCodeAt(i)===47){if(f===0){d="/"
break}--f
d="/"}}if(i===g&&a.b<=0&&!B.a.R(h,"/",j)){n-=f*3
d=""}o=i-n+d.length
return new A.bk(B.a.t(h,0,i)+d+B.a.a0(s,n),a.b,a.c,a.d,j,c+o,b.r+o,a.w)},
hi(){var s,r=this,q=r.b
if(q>=0){s=!(q===4&&B.a.K(r.a,"file"))
q=s}else q=!1
if(q)throw A.a(A.P("Cannot extract a file path from a "+r.gaD()+" URI"))
q=r.f
s=r.a
if(q<s.length){if(q<r.r)throw A.a(A.P(u.z))
throw A.a(A.P(u.A))}if(r.c<r.d)A.r(A.P(u.Q))
q=B.a.t(s,r.e,q)
return q},
gv(a){var s=this.x
return s==null?this.x=B.a.gv(this.a):s},
D(a,b){if(b==null)return!1
if(this===b)return!0
return t.R.b(b)&&this.a===b.j(0)},
iO(){var s=this,r=null,q=s.gaD(),p=s.ghk(),o=s.c>0?s.gbH():r,n=s.gfZ()?s.gdt():r,m=s.a,l=s.f,k=B.a.t(m,s.e,l),j=s.r
l=l<j?s.gdv():r
return A.hE(q,p,o,n,k,l,j<m.length?s.gei():r)},
j(a){return this.a},
$ijv:1}
A.jS.prototype={}
A.io.prototype={
i(a,b){var s=!0
s=typeof b=="string"
if(s)A.wR(b)
return this.a.get(b)},
l(a,b,c){this.a.set(b,c)},
j(a){return"Expando:null"}}
A.uf.prototype={
$0(){var s=v.G.performance
if(t.m.b(s))if(s.measure!=null&&s.mark!=null&&s.clearMeasures!=null&&s.clearMarks!=null)return s
return null},
$S:142}
A.ud.prototype={
$0(){var s=v.G.JSON
if(t.m.b(s))return s
throw A.a(A.P("Missing JSON.parse() support"))},
$S:19}
A.vN.prototype={}
A.iT.prototype={
j(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."},
$iO:1}
A.n3.prototype={
$2(a,b){this.a.bb(new A.n1(a),new A.n2(b),t.X)},
$S:136}
A.n1.prototype={
$1(a){var s=this.a
return s.call(s)},
$S:133}
A.n2.prototype={
$2(a,b){var s,r,q=t.g.a(v.G.Error),p=A.Ec(q,["Dart exception thrown from converted Future. Use the properties 'error' to fetch the boxed error and 'stack' to recover the stack trace."])
if(t.d9.b(a))A.r("Attempting to box non-Dart object.")
s={}
s[$.zH()]=a
p.error=s
p.stack=b.j(0)
r=this.a
r.call(r,p)},
$S:7}
A.uR.prototype={
$1(a){var s,r,q,p
if(A.yz(a))return a
s=this.a
if(s.E(a))return s.i(0,a)
if(t.av.b(a)){r={}
s.l(0,a,r)
for(s=J.Z(a.ga3());s.m();){q=s.gp()
r[q]=this.$1(a.i(0,q))}return r}else if(t.e7.b(a)){p=[]
s.l(0,a,p)
B.c.aa(p,J.dE(a,this,t.z))
return p}else return a},
$S:132}
A.v7.prototype={
$1(a){return this.a.T(a)},
$S:13}
A.v8.prototype={
$1(a){if(a==null)return this.a.ab(new A.iT(a===undefined))
return this.a.ab(a)},
$S:13}
A.rY.prototype={
er(a){if(a<=0||a>4294967296)throw A.a(A.az(u.E+a))
return Math.random()*a>>>0}}
A.rZ.prototype={
l8(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.a(A.P("No source of cryptographically secure random numbers available."))},
er(a){var s,r,q,p,o,n,m,l
if(a<=0||a>4294967296)throw A.a(A.az(u.E+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.C(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.R(Math.pow(256,s))
for(o=a-1,n=(a&o)===0;;){crypto.getRandomValues(J.cM(B.ag.gar(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}}}
A.ij.prototype={
gj_(){return this},
gv(a){return(J.V(this.a)^A.e0(this.b)^492929599)>>>0},
D(a,b){if(b==null)return!1
return b instanceof A.ij&&J.A(this.a,b.a)&&this.b===b.b}}
A.fV.prototype={
gj_(){return null},
gv(a){return B.ab.gv(this.a)^842997089},
D(a,b){if(b==null)return!1
return b instanceof A.fV}}
A.fI.prototype={
q(a,b){var s,r=this
if(r.b)throw A.a(A.z("Can't add a Stream to a closed StreamGroup."))
s=r.c
if(s===B.aH)r.e.cD(b,new A.oM())
else if(s===B.aG)return b.O(null).u()
else r.e.cD(b,new A.oN(r,b))
return null},
m8(){var s,r,q,p,o,n,m,l=this
l.c=B.aI
r=l.e
q=A.ap(new A.aG(r,A.p(r).h("aG<1,2>")),l.$ti.h("M<D<1>,ae<1>?>"))
p=q.length
o=0
for(;o<q.length;q.length===p||(0,A.a6)(q),++o){n=q[o]
if(n.b!=null)continue
s=n.a
try{r.l(0,s,l.ii(s))}catch(m){r=l.iK()
if(r!=null)r.j6(new A.oL())
throw m}}},
mH(){this.c=B.aJ
for(var s=this.e,s=new A.b6(s,s.r,s.e);s.m();)s.d.aj()},
mJ(){this.c=B.aI
for(var s=this.e,s=new A.b6(s,s.r,s.e);s.m();)s.d.am()},
iK(){var s,r,q,p
this.c=B.aG
s=this.e
r=A.p(s).h("aG<1,2>")
q=t.bC
p=A.ap(new A.fz(A.nU(new A.aG(s,r),new A.oK(this),r.h("n.E"),t.m2),q),q.h("n.E"))
s.au(0)
return p.length===0?null:A.n7(p,t.H)},
ii(a){var s,r=this.a
r===$&&A.L()
s=a.az(r.gc4(r),new A.oJ(this,a),r.gfG())
if(this.c===B.aJ)s.aj()
return s}}
A.oM.prototype={
$0(){return null},
$S:1}
A.oN.prototype={
$0(){return this.a.ii(this.b)},
$S(){return this.a.$ti.h("ae<1>()")}}
A.oL.prototype={
$1(a){},
$S:12}
A.oK.prototype={
$1(a){var s,r,q=a.b
try{if(q!=null){s=q.u()
return s}s=a.a.O(null).u()
return s}catch(r){return null}},
$S(){return this.a.$ti.h("o<~>?(M<D<1>,ae<1>?>)")}}
A.oJ.prototype={
$0(){var s=this.a,r=s.e,q=r.H(0,this.b),p=q==null?null:q.u()
if(r.a===0)if(s.b){s=s.a
s===$&&A.L()
A.eT(s.gaG())}return p},
$S:0}
A.eB.prototype={
j(a){return this.a}}
A.U.prototype={
i(a,b){var s,r=this
if(!r.fn(b))return null
s=r.c.i(0,r.a.$1(r.$ti.h("U.K").a(b)))
return s==null?null:s.b},
l(a,b,c){var s=this
if(!s.fn(b))return
s.c.l(0,s.a.$1(b),new A.M(b,c,s.$ti.h("M<U.K,U.V>")))},
aa(a,b){b.ad(0,new A.lz(this))},
bk(a,b,c){return this.c.bk(0,b,c)},
E(a){var s=this
if(!s.fn(a))return!1
return s.c.E(s.a.$1(s.$ti.h("U.K").a(a)))},
gbl(){var s=this.c,r=A.p(s).h("aG<1,2>")
return A.nU(new A.aG(s,r),new A.lA(this),r.h("n.E"),this.$ti.h("M<U.K,U.V>"))},
ad(a,b){this.c.ad(0,new A.lB(this,b))},
gF(a){return this.c.a===0},
ga3(){var s=this.c,r=A.p(s).h("bX<2>")
return A.nU(new A.bX(s,r),new A.lC(this),r.h("n.E"),this.$ti.h("U.K"))},
gk(a){return this.c.a},
cB(a,b,c,d){return this.c.cB(0,new A.lD(this,b,c,d),c,d)},
j(a){return A.nS(this)},
fn(a){return this.$ti.h("U.K").b(a)},
$ia_:1}
A.lz.prototype={
$2(a,b){this.a.l(0,a,b)
return b},
$S(){return this.a.$ti.h("~(U.K,U.V)")}}
A.lA.prototype={
$1(a){var s=a.b
return new A.M(s.a,s.b,this.a.$ti.h("M<U.K,U.V>"))},
$S(){return this.a.$ti.h("M<U.K,U.V>(M<U.C,M<U.K,U.V>>)")}}
A.lB.prototype={
$2(a,b){return this.b.$2(b.a,b.b)},
$S(){return this.a.$ti.h("~(U.C,M<U.K,U.V>)")}}
A.lC.prototype={
$1(a){return a.a},
$S(){return this.a.$ti.h("U.K(M<U.K,U.V>)")}}
A.lD.prototype={
$2(a,b){return this.b.$2(b.a,b.b)},
$S(){return this.a.$ti.I(this.c).I(this.d).h("M<1,2>(U.C,M<U.K,U.V>)")}}
A.f8.prototype={
bG(a,b){return J.A(a,b)},
h_(a){return J.V(a)},
on(a){return!0}}
A.eE.prototype={
bG(a,b){var s,r,q,p,o
if(a===b)return!0
s=A.vq(B.C.gnL(),B.C.gof(),B.C.gom(),this.$ti.h("eE.E"),t.S)
for(r=a.gA(a),q=0;r.m();){p=r.gp()
o=s.i(0,p)
s.l(0,p,(o==null?0:o)+1);++q}for(r=b.gA(b);r.m();){p=r.gp()
o=s.i(0,p)
if(o==null||o===0)return!1
s.l(0,p,o-1);--q}return q===0}}
A.d9.prototype={}
A.ew.prototype={
gv(a){return 3*J.V(this.b)+7*J.V(this.c)&2147483647},
D(a,b){if(b==null)return!1
return b instanceof A.ew&&J.A(this.b,b.b)&&J.A(this.c,b.c)}}
A.iK.prototype={
bG(a,b){var s,r,q,p,o
if(a==b)return!0
if(a==null||b==null)return!1
if(a.gk(a)!==b.gk(b))return!1
s=A.vq(null,null,null,t.fA,t.S)
for(r=J.Z(a.ga3());r.m();){q=r.gp()
p=new A.ew(this,q,a.i(0,q))
o=s.i(0,p)
s.l(0,p,(o==null?0:o)+1)}for(r=J.Z(b.ga3());r.m();){q=r.gp()
p=new A.ew(this,q,b.i(0,q))
o=s.i(0,p)
if(o==null||o===0)return!1
s.l(0,p,o-1)}return!0},
h_(a){var s,r,q,p,o,n
if(a==null)return B.ab.gv(null)
for(s=J.Z(a.ga3()),r=this.$ti.y[1],q=0;s.m();){p=s.gp()
o=J.V(p)
n=a.i(0,p)
q=q+3*o+7*J.V(n==null?r.a(n):n)&2147483647}q=q+(q<<3>>>0)&2147483647
q^=q>>>11
return q+(q<<15>>>0)&2147483647}}
A.iR.prototype={
sk(a,b){A.xa()},
q(a,b){return A.xa()}}
A.js.prototype={
l(a,b,c){return A.Bx()}}
A.l4.prototype={}
A.ct.prototype={}
A.i_.prototype={
n(){},
$ilK:1}
A.i0.prototype={
nT(){if(this.w)throw A.a(A.z("Can't finalize a finalized Request."))
this.w=!0
return B.aL},
j(a){return this.a+" "+this.b.j(0)}}
A.lh.prototype={
$2(a,b){return a.toLowerCase()===b.toLowerCase()},
$S:115}
A.li.prototype={
$1(a){return B.a.gv(a.toLowerCase())},
$S:114}
A.lj.prototype={
eS(a,b,c,d,e,f,g){var s=this.b
if(s<100)throw A.a(A.J("Invalid status code "+s+".",null))
else{s=this.d
if(s!=null&&s<0)throw A.a(A.J("Invalid content length "+A.q(s)+".",null))}}}
A.i4.prototype={
ao(a){return this.kB(a)},
kB(b6){var s=0,r=A.i(t.n),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5
var $async$ao=A.d(function(b7,b8){if(b7===1){o.push(b8)
s=p}for(;;)switch(s){case 0:if(m.b)throw A.a(A.wL("HTTP request failed. Client is already closed.",b6.b))
a4=v.G
l=new a4.AbortController()
a5=m.c
a5.push(l)
b6.hx()
s=3
return A.b(new A.cP(A.xs(b6.y,t.f4)).hh(),$async$ao)
case 3:k=b8
p=5
j=b6
i=null
h=!1
g=null
if(j instanceof A.hR){if(h)a6=i
else{h=!0
a7=j.cx
i=a7
a6=a7}a6=a6!=null}else a6=!1
if(a6){if(h){a6=i
a8=a6}else{h=!0
a7=j.cx
i=a7
a8=a7}g=a8==null?t.p8.a(a8):a8
g.J(new A.ln(l))}a6=b6.b
a9=a6.j(0)
b0=!J.l0(k)?k:null
b1=t.N
f=A.T(b1,t.K)
e=b6.y.length
d=null
if(e!=null){d=e
J.kZ(f,"content-length",d)}for(b2=b6.r,b2=new A.aG(b2,A.p(b2).h("aG<1,2>")).gA(0);b2.m();){b3=b2.d
b3.toString
c=b3
J.kZ(f,c.a,c.b)}f=A.EI(f)
f.toString
A.S(f)
b2=l.signal
s=8
return A.b(A.ar(a4.fetch(a9,{method:b6.a,headers:f,body:b0,credentials:"same-origin",redirect:"follow",signal:b2}),t.m),$async$ao)
case 8:b=b8
a=b.headers.get("content-length")
a0=a!=null?A.vA(a,null):null
if(a0==null&&a!=null){f=A.wL("Invalid content-length header ["+a+"].",a6)
throw A.a(f)}a1=A.T(b1,b1)
b.headers.forEach(A.kM(new A.lo(a1)))
f=A.CR(b6,b)
a4=b.status
a6=a1
b0=a0
A.dg(b.url)
b1=b.statusText
f=new A.jl(A.ze(f),b6,a4,b1,b0,a6,!1,!0)
f.eS(a4,b0,a6,!1,!0,b1,b6)
q=f
n=[1]
s=6
break
n.push(7)
s=6
break
case 5:p=4
b5=o.pop()
a2=A.E(b5)
a3=A.I(b5)
A.yE(a2,a3,b6)
n.push(7)
s=6
break
case 4:n=[2]
case 6:p=2
B.c.H(a5,l)
s=n.pop()
break
case 7:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$ao,r)},
n(){var s,r,q
for(s=this.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q)s[q].abort()
this.b=!0}}
A.ln.prototype={
$0(){return this.a.abort()},
$S:0}
A.lo.prototype={
$3(a,b,c){this.a.l(0,b.toLowerCase(),a)},
$2(a,b){return this.$3(a,b,null)},
$S:108}
A.u3.prototype={
$1(a){return A.eN(this.a,this.b,a)},
$S:107}
A.ug.prototype={
$0(){var s=this.a,r=s.a
if(r!=null){s.a=null
r.L()}},
$S:0}
A.uh.prototype={
$0(){var s=0,r=A.i(t.H),q=1,p=[],o=this,n,m,l,k
var $async$$0=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:q=3
o.a.c=!0
s=6
return A.b(A.ar(o.b.cancel(),t.X),$async$$0)
case 6:q=1
s=5
break
case 3:q=2
k=p.pop()
n=A.E(k)
m=A.I(k)
if(!o.a.b)A.yE(n,m,o.c)
s=5
break
case 2:s=1
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:3}
A.cP.prototype={
hh(){var s=new A.l($.m,t.jz),r=new A.aa(s,t.iq),q=new A.jO(new A.ly(r),new Uint8Array(1024))
this.B(q.gc4(q),!0,q.gaG(),r.gn9())
return s}}
A.ly.prototype={
$1(a){return this.a.T(new Uint8Array(A.w8(a)))},
$S:106}
A.bR.prototype={
j(a){var s=this.b,r="ClientException: "+this.a
if(s!=null)return r+", uri="+s.j(0)
else return r},
$iO:1}
A.os.prototype={
gfS(){var s,r
if(this.gbD()==null||!this.gbD().c.a.E("charset"))return B.l
s=this.gbD().c.a.i(0,"charset")
s.toString
r=A.wP(s)
return r==null?A.r(A.ak('Unsupported encoding "'+s+'".',null,null)):r},
sj5(a){var s,r,q,p,o,n,m=this,l=m.gfS().b8(a)
m.lk()
m.y=A.zf(l)
s=m.gbD()
if(s==null){l=t.N
m.sbD(A.nV("text","plain",A.bE(["charset",m.gfS().gbK()],l,l)))}else{l=m.gbD()
if(l!=null){r=l.a
if(r!=="text"){l=r+"/"+l.b
l=l==="application/xml"||l==="application/xml-external-parsed-entity"||l==="application/xml-dtd"||B.a.bF(l,"+xml")}else l=!0}else l=!1
if(l&&!s.c.a.E("charset")){l=t.N
q=A.bE(["charset",m.gfS().gbK()],l,l)
p=s.a
o=s.b
n=A.x3(s.c,l,l)
n.aa(0,q)
m.sbD(A.nV(p,o,n))}}},
gbD(){var s=this.r.i(0,"content-type")
if(s==null)return null
return A.x7(s)},
sbD(a){this.r.l(0,"content-type",a.j(0))},
lk(){if(!this.w)return
throw A.a(A.z("Can't modify a finalized Request."))}}
A.hR.prototype={}
A.jE.prototype={}
A.e3.prototype={}
A.cw.prototype={}
A.jl.prototype={}
A.eZ.prototype={}
A.ft.prototype={
j(a){var s=new A.a0(""),r=this.a
s.a=r
r+="/"
s.a=r
s.a=r+this.b
this.c.a.ad(0,new A.nY(s))
r=s.a
return r.charCodeAt(0)==0?r:r}}
A.nW.prototype={
$0(){var s,r,q,p,o,n,m,l,k,j=this.a,i=new A.pc(null,j),h=$.zS()
i.eO(h)
s=$.zR()
i.de(s)
r=i.gh4().i(0,0)
r.toString
i.de("/")
i.de(s)
q=i.gh4().i(0,0)
q.toString
i.eO(h)
p=t.N
o=A.T(p,p)
for(;;){p=i.d=B.a.cC(";",j,i.c)
n=i.e=i.c
m=p!=null
p=m?i.e=i.c=p.gC():n
if(!m)break
p=i.d=h.cC(0,j,p)
i.e=i.c
if(p!=null)i.e=i.c=p.gC()
i.de(s)
if(i.c!==i.e)i.d=null
p=i.d.i(0,0)
p.toString
i.de("=")
n=i.d=s.cC(0,j,i.c)
l=i.e=i.c
m=n!=null
if(m){n=i.e=i.c=n.gC()
l=n}else n=l
if(m){if(n!==l)i.d=null
n=i.d.i(0,0)
n.toString
k=n}else k=A.Eq(i)
n=i.d=h.cC(0,j,i.c)
i.e=i.c
if(n!=null)i.e=i.c=n.gC()
o.l(0,p,k)}i.nQ()
return A.nV(r,q,o)},
$S:104}
A.nY.prototype={
$2(a,b){var s,r,q=this.a
q.a+="; "+a+"="
s=$.zP()
s=s.b.test(b)
r=q.a
if(s){q.a=r+'"'
s=A.zb(b,$.zE(),new A.nX(),null)
q.a=(q.a+=s)+'"'}else q.a=r+b},
$S:45}
A.nX.prototype={
$1(a){return"\\"+A.q(a.i(0,0))},
$S:46}
A.uF.prototype={
$1(a){var s=a.i(0,1)
s.toString
return s},
$S:46}
A.co.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.co&&this.b===b.b},
a_(a,b){return this.b-b.b},
gv(a){return this.b},
j(a){return this.a},
$ia7:1}
A.dU.prototype={
j(a){return"["+this.a.a+"] "+this.d+": "+this.b}}
A.dV.prototype={
gjp(){var s=this.b,r=s==null?null:s.a.length!==0,q=this.a
return r===!0?s.gjp()+"."+q:q},
goq(){var s,r
if(this.b==null){s=this.c
s.toString
r=s}else{s=$.vh().c
s.toString
r=s}return r},
P(a,b,c,d){var s,r,q=this,p=a.b
if(p>=q.goq().b){if((d==null||d===B.t)&&p>=2000){d=A.fH()
if(c==null)c="autogenerated stack trace for "+a.j(0)+" "+b}p=q.gjp()
s=Date.now()
$.x4=$.x4+1
r=new A.dU(a,b,p,new A.bT(s,0,!1),c,d)
if(q.b==null)q.is(r)
else $.vh().is(r)}},
oz(a,b){return this.P(a,b,null,null)},
fc(){if(this.b==null){var s=this.f
if(s==null)s=this.f=A.c3(!0,t.ag)
return new A.aq(s,A.p(s).h("aq<1>"))}else return $.vh().fc()},
is(a){var s=this.f
return s==null?null:s.q(0,a)}}
A.nQ.prototype={
$0(){var s,r,q=this.a
if(B.a.K(q,"."))A.r(A.J("name shouldn't start with a '.'",null))
if(B.a.bF(q,"."))A.r(A.J("name shouldn't end with a '.'",null))
s=B.a.cA(q,".")
if(s===-1)r=q!==""?A.vz(""):null
else{r=A.vz(B.a.t(q,0,s))
q=B.a.a0(q,s+1)}return A.x5(q,r,A.T(t.N,t.W))},
$S:97}
A.m0.prototype={
mY(a){var s,r,q=t.mf
A.yP("absolute",A.u([a,null,null,null,null,null,null,null,null,null,null,null,null,null,null],q))
s=this.a
s=s.aA(a)>0&&!s.bI(a)
if(s)return a
s=A.yW()
r=A.u([s,a,null,null,null,null,null,null,null,null,null,null,null,null,null,null],q)
A.yP("join",r)
return this.op(new A.fX(r,t.lS))},
op(a){var s,r,q,p,o,n,m,l,k
for(s=a.gA(0),r=new A.ef(s,new A.m1()),q=this.a,p=!1,o=!1,n="";r.m();){m=s.gp()
if(q.bI(m)&&o){l=A.iW(m,q)
k=n.charCodeAt(0)==0?n:n
n=B.a.t(k,0,q.cG(k,!0))
l.b=n
if(q.dr(n))l.e[0]=q.gcg()
n=l.j(0)}else if(q.aA(m)>0){o=!q.bI(m)
n=m}else{if(!(m.length!==0&&q.fN(m[0])))if(p)n+=q.gcg()
n+=m}p=q.dr(m)}return n.charCodeAt(0)==0?n:n},
dL(a,b){var s=A.iW(b,this.a),r=s.d,q=A.a5(r).h("c7<1>")
r=A.ap(new A.c7(r,new A.m2(),q),q.h("n.E"))
s.d=r
q=s.b
if(q!=null)B.c.ol(r,0,q)
return s.d},
h8(a){var s
if(!this.m_(a))return a
s=A.iW(a,this.a)
s.h7()
return s.j(0)},
m_(a){var s,r,q,p,o,n,m,l=this.a,k=l.aA(a)
if(k!==0){if(l===$.kW())for(s=0;s<k;++s)if(a.charCodeAt(s)===47)return!0
r=k
q=47}else{r=0
q=null}for(p=a.length,s=r,o=null;s<p;++s,o=q,q=n){n=a.charCodeAt(s)
if(l.bo(n)){if(l===$.kW()&&n===47)return!0
if(q!=null&&l.bo(q))return!0
if(q===46)m=o==null||o===46||l.bo(o)
else m=!1
if(m)return!0}}if(q==null)return!0
if(l.bo(q))return!0
if(q===46)l=o==null||l.bo(o)||o===46
else l=!1
if(l)return!0
return!1},
oT(a){var s,r,q,p,o=this,n='Unable to find a path to "',m=o.a,l=m.aA(a)
if(l<=0)return o.h8(a)
s=A.yW()
if(m.aA(s)<=0&&m.aA(a)>0)return o.h8(a)
if(m.aA(a)<=0||m.bI(a))a=o.mY(a)
if(m.aA(a)<=0&&m.aA(s)>0)throw A.a(A.xb(n+a+'" from "'+s+'".'))
r=A.iW(s,m)
r.h7()
q=A.iW(a,m)
q.h7()
l=r.d
if(l.length!==0&&l[0]===".")return q.j(0)
l=r.b
p=q.b
if(l!=p)l=l==null||p==null||!m.hc(l,p)
else l=!1
if(l)return q.j(0)
for(;;){l=r.d
if(l.length!==0){p=q.d
l=p.length!==0&&m.hc(l[0],p[0])}else l=!1
if(!l)break
B.c.ex(r.d,0)
B.c.ex(r.e,1)
B.c.ex(q.d,0)
B.c.ex(q.e,1)}l=r.d
p=l.length
if(p!==0&&l[0]==="..")throw A.a(A.xb(n+a+'" from "'+s+'".'))
l=t.N
B.c.h0(q.d,0,A.b7(p,"..",!1,l))
p=q.e
p[0]=""
B.c.h0(p,1,A.b7(r.d.length,m.gcg(),!1,l))
m=q.d
l=m.length
if(l===0)return"."
if(l>1&&B.c.gaQ(m)==="."){B.c.jO(q.d)
m=q.e
m.pop()
m.pop()
m.push("")}q.b=""
q.jP()
return q.j(0)},
jI(a){var s,r,q=this,p=A.yB(a)
if(p.gaD()==="file"&&q.a===$.hN())return p.j(0)
else if(p.gaD()!=="file"&&p.gaD()!==""&&q.a!==$.hN())return p.j(0)
s=q.h8(q.a.hb(A.yB(p)))
r=q.oT(s)
return q.dL(0,r).length>q.dL(0,s).length?s:r}}
A.m1.prototype={
$1(a){return a!==""},
$S:25}
A.m2.prototype={
$1(a){return a.length!==0},
$S:25}
A.ux.prototype={
$1(a){return a==null?"null":'"'+a+'"'},
$S:90}
A.nG.prototype={
kw(a){var s=this.aA(a)
if(s>0)return B.a.t(a,0,s)
return this.bI(a)?a[0]:null},
hc(a,b){return a===b}}
A.o2.prototype={
jP(){var s,r,q=this
for(;;){s=q.d
if(!(s.length!==0&&B.c.gaQ(s)===""))break
B.c.jO(q.d)
q.e.pop()}s=q.e
r=s.length
if(r!==0)s[r-1]=""},
h7(){var s,r,q,p,o,n=this,m=A.u([],t.s)
for(s=n.d,r=s.length,q=0,p=0;p<s.length;s.length===r||(0,A.a6)(s),++p){o=s[p]
if(!(o==="."||o===""))if(o==="..")if(m.length!==0)m.pop()
else ++q
else m.push(o)}if(n.b==null)B.c.h0(m,0,A.b7(q,"..",!1,t.N))
if(m.length===0&&n.b==null)m.push(".")
n.d=m
s=n.a
n.e=A.b7(m.length+1,s.gcg(),!0,t.N)
r=n.b
if(r==null||m.length===0||!s.dr(r))n.e[0]=""
r=n.b
if(r!=null&&s===$.kW())n.b=A.hM(r,"/","\\")
n.jP()},
j(a){var s,r,q,p,o=this.b
o=o!=null?o:""
for(s=this.d,r=s.length,q=this.e,p=0;p<r;++p)o=o+q[p]+s[p]
o+=B.c.gaQ(q)
return o.charCodeAt(0)==0?o:o}}
A.iX.prototype={
j(a){return"PathException: "+this.a},
$iO:1}
A.pd.prototype={
j(a){return this.gbK()}}
A.o3.prototype={
fN(a){return B.a.U(a,"/")},
bo(a){return a===47},
dr(a){var s=a.length
return s!==0&&a.charCodeAt(s-1)!==47},
cG(a,b){if(a.length!==0&&a.charCodeAt(0)===47)return 1
return 0},
aA(a){return this.cG(a,!1)},
bI(a){return!1},
hb(a){var s
if(a.gaD()===""||a.gaD()==="file"){s=a.gaR()
return A.w2(s,0,s.length,B.l,!1)}throw A.a(A.J("Uri "+a.j(0)+" must have scheme 'file:'.",null))},
gbK(){return"posix"},
gcg(){return"/"}}
A.pP.prototype={
fN(a){return B.a.U(a,"/")},
bo(a){return a===47},
dr(a){var s=a.length
if(s===0)return!1
if(a.charCodeAt(s-1)!==47)return!0
return B.a.bF(a,"://")&&this.aA(a)===s},
cG(a,b){var s,r,q,p=a.length
if(p===0)return 0
if(a.charCodeAt(0)===47)return 1
for(s=0;s<p;++s){r=a.charCodeAt(s)
if(r===47)return 0
if(r===58){if(s===0)return 0
q=B.a.bn(a,"/",B.a.R(a,"//",s+1)?s+3:s)
if(q<=0)return p
if(!b||p<q+3)return q
if(!B.a.K(a,"file://"))return q
p=A.yX(a,q+1)
return p==null?q:p}}return 0},
aA(a){return this.cG(a,!1)},
bI(a){return a.length!==0&&a.charCodeAt(0)===47},
hb(a){return a.j(0)},
gbK(){return"url"},
gcg(){return"/"}}
A.qi.prototype={
fN(a){return B.a.U(a,"/")},
bo(a){return a===47||a===92},
dr(a){var s=a.length
if(s===0)return!1
s=a.charCodeAt(s-1)
return!(s===47||s===92)},
cG(a,b){var s,r=a.length
if(r===0)return 0
if(a.charCodeAt(0)===47)return 1
if(a.charCodeAt(0)===92){if(r<2||a.charCodeAt(1)!==92)return 1
s=B.a.bn(a,"\\",2)
if(s>0){s=B.a.bn(a,"\\",s+1)
if(s>0)return s}return r}if(r<3)return 0
if(!A.z0(a.charCodeAt(0)))return 0
if(a.charCodeAt(1)!==58)return 0
r=a.charCodeAt(2)
if(!(r===47||r===92))return 0
return 3},
aA(a){return this.cG(a,!1)},
bI(a){return this.aA(a)===1},
hb(a){var s,r
if(a.gaD()!==""&&a.gaD()!=="file")throw A.a(A.J("Uri "+a.j(0)+" must have scheme 'file:'.",null))
s=a.gaR()
if(a.gbH()===""){r=s.length
if(r>=3&&B.a.K(s,"/")&&A.yX(s,1)!=null){A.xm(0,0,r,"startIndex")
s=A.F0(s,"/","",0)}}else s="\\\\"+a.gbH()+s
r=A.hM(s,"/","\\")
return A.w2(r,0,r.length,B.l,!1)},
n8(a,b){var s
if(a===b)return!0
if(a===47)return b===92
if(a===92)return b===47
if((a^b)!==32)return!1
s=a|32
return s>=97&&s<=122},
hc(a,b){var s,r
if(a===b)return!0
s=a.length
if(s!==b.length)return!1
for(r=0;r<s;++r)if(!this.n8(a.charCodeAt(r),b.charCodeAt(r)))return!1
return!0},
gbK(){return"windows"},
gcg(){return"\\"}}
A.hQ.prototype={
aq(){var s=0,r=A.i(t.H),q=this,p,o,n,m
var $async$aq=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if((q.a.a.a&30)===0){for(p=q.b,o=A.Ch(p,p.r,A.p(p).c),n=o.$ti.c;o.m();){m=o.d;(m==null?n.a(m):m).L()}p.au(0)}s=2
return A.b(q.c.a,$async$aq)
case 2:return A.f(null,r)}})
return A.h($async$aq,r)},
j9(){var s=this.c
if((s.a.a&30)===0)s.L()},
b1(a,b){var s=new A.aa(new A.l($.m,t.D),t.h)
if((this.a.a.a&30)!==0)s.L()
else this.b.q(0,s)
return A.dP(new A.l2(a,s,b),b).J(new A.l3(this,s))}}
A.l2.prototype={
$0(){return this.a.$1(this.b.a)},
$S(){return this.c.h("o<0>()")}}
A.l3.prototype={
$0(){var s=this.b
this.a.b.H(0,s)
if((s.a.a&30)===0)s.L()},
$S:1}
A.cr.prototype={
j(a){return"PowerSyncCredentials<endpoint: "+this.a+" userId: "+A.q(this.c)+" expiresAt: "+A.q(this.d)+">"}}
A.f6.prototype={
eA(){var s=this
return A.bE(["op_id",s.a,"op",s.c.c,"type",s.d,"id",s.e,"tx_id",s.b,"data",s.r,"metadata",s.f,"old",s.w],t.N,t.z)},
j(a){var s=this
return"CrudEntry<"+s.b+"/"+s.a+" "+s.c.c+" "+s.d+"/"+s.e+" "+A.q(s.r)+">"},
D(a,b){var s=this
if(b==null)return!1
return b instanceof A.f6&&b.b===s.b&&b.a===s.a&&b.c===s.c&&b.d===s.d&&b.e===s.e&&B.y.bG(b.r,s.r)},
gv(a){var s=this
return A.c0(s.b,s.a,s.c.c,s.d,s.e,B.y.h_(s.r))}}
A.fT.prototype={
aF(){return"UpdateType."+this.b},
eA(){return this.c}}
A.v5.prototype={
$1(a){return new A.bf(A.w9(a.a))},
$S:78}
A.v4.prototype={
$1(a){var s=a.a
return s.gaP(s)},
$S:77}
A.f5.prototype={
j(a){return"CredentialsException: "+this.a},
$iO:1}
A.e_.prototype={
j(a){return"SyncProtocolException: "+this.a},
$iO:1}
A.dc.prototype={
j(a){return"SyncResponseException: "+this.a+" "+this.b},
$iO:1}
A.ue.prototype={
$1(a){var s
A.v6("["+a.d+"] "+a.a.a+": "+a.e.j(0)+": "+a.b)
s=a.r
if(s!=null)A.v6(s)
s=a.w
if(s!=null)A.v6(s)},
$S:52}
A.cZ.prototype={
j(a){return v.G.String(this.a)},
gv(a){return A.R(v.G.Number(this.a))},
D(a,b){if(b==null)return!1
return b instanceof A.cZ&&this.a===b.a},
$idQ:1}
A.bf.prototype={
cH(a){var s=this.a
if(a instanceof A.bf)return new A.bf(s.cH(a.a))
else return new A.bf(s.cH(A.w9(a.a)))},
fM(a){return this.kQ(A.w9(a))}}
A.lw.prototype={
$1(a){return a.b0(this.a,this.b)},
$S(){return this.b.h("o<0>(aK)")}}
A.lu.prototype={
$1(a){return this.k0(a)},
k0(a){var s=0,r=A.i(t.I),q,p
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.d4(a,"target",null),$async$$1)
case 3:if(c!=="9223372036854775807"){q=null
s=1
break}s=4
return A.b(a.dH("SELECT 1 FROM ps_crud LIMIT 1"),$async$$1)
case 4:if(c!=null){q=null
s=1
break}s=5
return A.b(a.dH(u.B),$async$$1)
case 5:p=c
q=A.w4(p==null?null:p.i(0,"seq"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:65}
A.lv.prototype={
$1(a){return this.k_(a)},
k_(a){var s=0,r=A.i(t.y),q,p=this,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(a.jh("SELECT 1 FROM ps_crud LIMIT 1"),$async$$1)
case 3:n=c
if(!n.gF(n)){q=!1
s=1
break}s=4
return A.b(a.jh(u.B),$async$$1)
case 4:o=c
if(A.R(o.gai(o).i(0,"seq"))!==p.a){q=!1
s=1
break}s=5
return A.b(A.d4(a,"target",p.b),$async$$1)
case 5:q=!0
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:62}
A.lq.prototype={
$1(a){return this.jZ(a)},
jZ(a){var s=0,r=A.i(t.N),q,p=this,o
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.iZ(a,p.a,p.b),$async$$1)
case 3:o=c
o.toString
q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:43}
A.dH.prototype={
j(a){return this.a},
$iO:1}
A.lI.prototype={
hl(a,b){var s=this.b
return A.BG(new A.aq(s,A.p(s).h("aq<1>")),a,this.a,"waitForCheckpointRequestsReady",new A.lJ(this,b),t.hi)},
pc(a){return this.hl(a,!0)}}
A.lJ.prototype={
$1(a){var s,r,q
if(a instanceof A.h8)throw A.a(B.A)
s=a instanceof A.ei
r=s?a.a:null
if(s){q=r.gj_()
if(q!=null)A.il(q.a,q.b)
return!0}if(a instanceof A.hm){if(this.b&&(this.a.c.a.a&30)===0)this.a.c.L()
return!1}},
$S:56}
A.ca.prototype={}
A.hm.prototype={}
A.ei.prototype={}
A.h8.prototype={}
A.fr.prototype={$ias:1,$ib9:1}
A.dN.prototype={$ias:1}
A.lH.prototype={}
A.fS.prototype={$ias:1,$ib9:1}
A.m4.prototype={}
A.m5.prototype={
$1(a){return A.Am(t.f.a(a))},
$S:57}
A.mQ.prototype={
eA(){var s,r,q,p,o=t.N,n=A.T(o,t.dV)
for(s=this.a,s=new A.aG(s,A.p(s).h("aG<1,2>")).gA(0),r=t.S;s.m();){q=s.d
p=q.a
q=q.b.a
n.l(0,p,A.bE(["priority",q[1],"at_last",q[0],"since_last",q[2],"target_count",q[3]],o,r))}return A.bE(["buckets",n],o,t.X)}}
A.mR.prototype={
$2(a,b){var s
t.f.a(b)
s=A.R(b.i(0,"priority"))
return new A.M(a,new A.ki([A.R(b.i(0,"at_last")),s,A.R(b.i(0,"since_last")),A.R(b.i(0,"target_count"))]),t.lx)},
$S:58}
A.fd.prototype={$ias:1,$ib9:1}
A.dI.prototype={$ias:1}
A.f9.prototype={$ias:1,$ib9:1}
A.f0.prototype={$ias:1,$ib9:1}
A.fh.prototype={$ias:1,$ib9:1}
A.fQ.prototype={$ias:1,$ib9:1}
A.nF.prototype={}
A.fM.prototype={}
A.lG.prototype={}
A.fp.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.fp},
gv(a){return B.a.gv("legacy")}}
A.d7.prototype={
D(a,b){var s
if(b==null)return!1
if(b instanceof A.d7)s=b.a.a===this.a.a
else s=!1
return s},
gv(a){return B.b.gv(this.a.a)}}
A.pe.prototype={
aF(){return"SyncClientImplementation."+this.b}}
A.aL.prototype={
j(a){var s,r,q=this,p=A.u([],t.iE),o=q.a
if(o!=null)p.push(new A.Q("core",o.a))
s=q.b
if(s!=null)p.push(new A.Q("uploading",s))
r=q.c
if(r!=null)p.push(new A.Q("downloadError",A.xw(null,r)))
r=q.d
if(r!=null)p.push(new A.Q("uploadError",A.xw(null,r)))
return"SyncStatusUpdate("+new A.a8(p,new A.pm(),t.eK).bp(0,", ")+")"}}
A.pm.prototype={
$1(a){return a.a+": "+A.q(a.b)},
$S:59}
A.dL.prototype={
eA(){var s,r,q,p,o=this,n=o.d,m=t.N
n=A.bE(["total",n.b,"downloaded",n.a],m,t.S)
s=o.w
A:{if(s==null){r=null
break A}r=1000*s.a+s.b
break A}q=o.x
B:{if(q==null){p=null
break B}p=1000*q.a+q.b
break B}return A.bE(["name",o.a,"parameters",o.b,"priority",o.c,"progress",n,"active",o.e,"is_default",o.f,"has_explicit_subscription",o.r,"expires_at",r,"last_synced_at",p],m,t.X)}}
A.uZ.prototype={
$0(){var s=this,r=s.b,q=s.a,p=s.d,o=A.a5(r).h("@<1>").I(p.h("ae<0>")).h("a8<1,2>"),n=A.ap(new A.a8(r,new A.uY(q,s.c,p),o),o.h("X.E"))
q.a=n},
$S:0}
A.uY.prototype={
$1(a){var s=this.b
return a.az(new A.uW(s,this.c),new A.uX(this.a,s),s.gfG())},
$S(){return this.c.h("ae<0>(D<0>)")}}
A.uW.prototype={
$1(a){return this.a.q(0,a)},
$S(){return this.b.h("~(0)")}}
A.uX.prototype={
$0(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i
var $async$$0=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:j=n.a
s=!j.b?2:3
break
case 2:j.b=!0
q=5
j=j.a
j.toString
s=8
return A.b(A.kP(j),$async$$0)
case 8:o.push(7)
s=6
break
case 5:q=4
i=p.pop()
m=A.E(i)
l=A.I(i)
n.b.ag(m,l)
o.push(7)
s=6
break
case 4:o=[1]
case 6:q=1
n.b.n()
s=o.pop()
break
case 7:case 3:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:3}
A.v_.prototype={
$0(){var s=this.a,r=s.a
if(r!=null&&!s.b)return A.kP(r)},
$S:36}
A.v0.prototype={
$0(){var s=this.a.a
if(s!=null)return A.EP(s)},
$S:0}
A.v1.prototype={
$0(){var s=this.a.a
if(s!=null)return A.ET(s)},
$S:0}
A.uA.prototype={
$1(a){return a.u()},
$S:60}
A.ve.prototype={
$1(a){var s=this.a
s.q(0,a)
s.n()},
$S(){return this.b.h("F(0)")}}
A.vf.prototype={
$2(a,b){var s
if(this.a.a)throw A.a(a)
else{s=this.b
s.ag(a,b)
s.n()}},
$S:7}
A.vd.prototype={
$0(){var s=0,r=A.i(t.H),q=this
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q.a.a=!0
s=2
return A.b(q.b,$async$$0)
case 2:return A.f(null,r)}})
return A.h($async$$0,r)},
$S:3}
A.pQ.prototype={
$1(a){var s,r,q,p=this
try{if(p.a.$1(a)){p.b.L()
p.c.u()}}catch(q){s=A.E(q)
r=A.I(q)
p.b.b7(s,r)
p.c.u()}},
$S(){return this.d.h("~(0)")}}
A.pR.prototype={
$0(){var s=this.a
if((s.a.a&30)===0){s.ab(new A.bC(this.b))
this.c.u()}},
$S:1}
A.eh.prototype={
q(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f="Stream is already closed"
for(s=J.ab(b),r=h.b,q=h.a.a,p=0;p<s.gk(b);){o=s.gk(b)-p
n=h.d
m=h.c
if(n!=null){l=Math.min(o,m)
k=p+l
if(p<0)A.r(A.ac(p,0,g,"start",g))
if(p>k)A.r(A.ac(k,p,g,"end",g))
n.hE(b,p,k)
if((h.c-=l)===0){m=B.f.gar(n.a)
j=n.a
j=J.cM(m,j.byteOffset,n.b*j.BYTES_PER_ELEMENT)
if((q.e&2)!==0)A.r(A.z(f))
q.bT(j)
h.d=null
h.c=4}p=k}else{l=Math.min(o,m)
i=J.zV(B.ag.gar(r))
m=4-h.c
B.f.X(i,m,m+l,b,p)
p+=l
if((h.c-=l)===0){m=h.c=r.getInt32(0,!0)-4
if(m<5){j=A.fH()
if((q.e&2)!==0)A.r(A.z(f))
q.eR(new A.e_("Invalid length for bson: "+m),j)}m=new A.bg(new Uint8Array(0),0)
m.hE(i,0,g)
h.d=m}}}},
ag(a,b){this.a.ag(a,b)},
n(){var s=this
if(s.d!=null||s.c!==4)s.a.ag(new A.e_("Pending data when stream was closed"),A.fH())
s.a.a.Z()},
$iaj:1,
gk(a){return this.b}}
A.oY.prototype={
aq(){var s=0,r=A.i(t.H),q=this,p
var $async$aq=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=q.at
s=p!=null?2:3
break
case 2:q.w.n()
s=4
return A.b(A.Az(new A.Q(p.aq(),q.ch.n()),t.H,t.z),$async$aq)
case 4:case 3:q.y.n()
q.Q.n()
return A.f(null,r)}})
return A.h($async$aq,r)},
cR(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g
var $async$cR=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:g=A.A4()
n.at=g
m=g
q=2
s=5
return A.b(n.co(),$async$cR)
case 5:h=n.c
l=h.a
k=h.b
j=null
if(k!=null)j=n.cl(m,k)
else if(l!=null)j=n.d2(l,m)
h=t.M
i=A.u([],h)
if(j!=null)J.hP(i,A.is(j,new A.pb(n,m),t.H,t.K))
if(l!=null)J.zT(i,A.u([n.cV(m,l),n.d1(l,m)],h))
s=6
return A.b(A.vp(i,t.H),$async$cR)
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
i=n.as
i.a=B.a6
i.b.q(0,B.a6)
m.j9()
s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$cR,r)},
ey(){var s=0,r=A.i(t.g2),q,p=2,o=[],n=this,m,l,k,j,i,h,g
var $async$ey=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:h=n.d.w
if(!((h==null?B.r:h) instanceof A.d7))throw A.a(B.b8)
m=n.c.a
if(m==null)throw A.a(B.A)
l=n.at
if(l==null||(l.a.a.a&30)!==0)throw A.a(B.A)
p=4
s=7
return A.b(n.iC(m,l),$async$ey)
case 7:k=b
h=v.G.BigInt(k)
q=new A.cZ(h)
s=1
break
p=2
s=6
break
case 4:p=3
g=o.pop()
j=A.E(g)
if(A.eJ(l,j))throw A.a(B.A)
throw g
s=6
break
case 3:s=2
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$ey,r)},
co(){var s=0,r=A.i(t.N),q,p=this,o
var $async$co=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.cx
s=o==null?3:5
break
case 3:s=6
return A.b(A.lr(p.b),$async$co)
case 6:b=p.cx=b
s=4
break
case 5:b=o
case 4:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$co,r)},
cV(a,b){return this.lx(a,b)},
lx(a1,a2){var s=0,r=A.i(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$cV=A.d(function(a3,a4){if(a3===1){o.push(a4)
s=p}for(;;)switch(s){case 0:g=a1.a.a,f=n.f,e=n.Q,d=n.ax,c=t.U,b=t.H
case 3:if(!((g.a&30)===0)){s=4
break}m=!1
p=6
l=null
s=9
return A.b(d.bJ(new A.p0(n,a1,a2),n.dP(a1),c),$async$cV)
case 9:k=a4
l=k.a
m=!l
p=2
s=8
break
case 6:p=5
a0=o.pop()
j=A.E(a0)
i=A.I(a0)
if(A.eJ(a1,j)){s=1
break}m=!0
h=A.DQ(j)
f.P(B.i,"Sync error: "+A.q(h),j,i)
if(!e.gal())A.r(e.ak())
e.a1(new A.aL(null,null,j,null))
s=8
break
case 5:s=2
break
case 8:s=(g.a&30)===0&&m?10:11
break
case 10:s=12
return A.b(a1.b1(new A.p1(n),b),$async$cV)
case 12:case 11:s=3
break
case 4:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$cV,r)},
cl(a,b){return this.lu(a,b)},
lu(a,b){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k
var $async$cl=A.d(function(c,d){if(c===1){p.push(d)
s=q}for(;;)switch(s){case 0:l=n.w
k=t.H
l=new A.bP(A.bd(A.z3(A.u([n.r,new A.a4(l,A.p(l).h("a4<1>"))],t.i3),k),"stream",t.K))
q=2
m=n.ay
case 5:s=7
return A.b(l.m(),$async$cl)
case 7:if(!d){s=6
break}l.gp()
s=8
return A.b(m.bJ(new A.oZ(n,a,b),n.dP(a),k),$async$cl)
case 8:s=5
break
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
s=9
return A.b(l.u(),$async$cl)
case 9:s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$cl,r)},
bW(a,b){return this.lv(a,b)},
lv(a8,a9){var s=0,r=A.i(t.H),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7
var $async$bW=A.d(function(b0,b1){if(b0===1){o.push(b1)
s=p}for(;;)switch(s){case 0:a6=null
f=a8.a.a,e=m.Q,d=m.c.a,c=d!=null,b=m.f,a=a9.gp9(),a0=t.H,a1=m.b,a2=m.ch
case 3:if(!((f.a&30)===0)){s=4
break}l=!1
p=6
s=9
return A.b(A.lt(a1),$async$bW)
case 9:k=b1
s=k!=null?10:12
break
case 10:if(!e.gal())A.r(e.ak())
e.a1(new A.aL(null,!0,null,null))
a3=k.a
a4=a6
if(a3===(a4==null?null:a4.a)){b.P(B.i,"Potentially previously uploaded CRUD entries are still present in the upload queue. \n                Make sure to handle uploads and complete CRUD transactions or batches by calling and awaiting their [.complete()] method.\n                The next upload iteration will be delayed.",null,null)
a3=A.wQ("Delaying due to previously encountered CRUD item.")
throw A.a(a3)}a6=k
s=13
return A.b(a8.b1(a,a0),$async$bW)
case 13:if(!e.gal())A.r(e.ak())
e.a1(new A.aL(null,null,null,B.w))
s=11
break
case 12:j=d
i=null
s=j!=null?14:15
break
case 14:i=j
s=16
return A.b(m.iS(i,a8),$async$bW)
case 16:l=b1
case 15:n=[4]
s=7
break
case 11:n.push(8)
s=7
break
case 6:p=5
a7=o.pop()
h=A.E(a7)
g=A.I(a7)
a6=null
if(A.eJ(a8,h)){n=[1]
s=7
break}b.P(B.i,"Data upload error",h,g)
if(!e.gal())A.r(e.ak())
e.a1(new A.aL(null,null,null,h))
s=17
return A.b(m.dP(a8),$async$bW)
case 17:if(c){a3=m.z
a3=(a3==null?null:a3.b)!==!0}else a3=!1
if(a3){n=[4]
s=7
break}b.P(B.i,"Caught exception when uploading. Upload will retry after a delay",h,g)
n.push(8)
s=7
break
case 5:n=[2]
case 7:p=2
if(!e.gal())A.r(e.ak())
e.a1(new A.aL(null,!1,null,null))
if((f.a&30)===0&&l){if(!a2.gal())A.r(a2.ak())
a2.a1(B.a5)}s=n.pop()
break
case 8:s=3
break
case 4:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$bW,r)},
d2(a,b){return this.ms(a,b)},
ms(a,b){var s=0,r=A.i(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e
var $async$d2=A.d(function(c,d){if(c===1){o.push(d)
s=p}for(;;)switch(s){case 0:j=b.a.a,i=n.f,h=n.Q,g=n.ch
case 3:if(!((j.a&30)===0)){s=4
break}p=6
s=9
return A.b(n.iS(a,b),$async$d2)
case 9:m=d
if(m){if(!g.gal())A.r(g.ak())
g.a1(B.a5)}if(!h.gal())A.r(h.ak())
h.a1(new A.aL(null,null,null,B.w))
s=1
break
p=2
s=8
break
case 6:p=5
e=o.pop()
l=A.E(e)
k=A.I(e)
if(A.eJ(b,l)){s=1
break}i.P(B.i,"Error requesting checkpoint after crud upload",l,k)
if(!h.gal())A.r(h.ak())
h.a1(new A.aL(null,null,null,l))
s=10
return A.b(n.dP(b),$async$d2)
case 10:s=8
break
case 5:s=2
break
case 8:s=3
break
case 4:h.q(0,new A.aL(null,!1,null,null))
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$d2,r)},
iS(a,b){return A.eY(this.b,new A.pa(this,a,b))},
eV(a,b){var s=a.r
s.l(0,"Authorization","Token "+b.b)
s.aa(0,this.CW)},
iC(a,b){return b.b1(new A.p9(this,a),t.N)},
b4(a,b,c,d){return this.mq(a,b,c,d)},
iB(a,b,c){return this.b4(a,b,c,null)},
mq(a,b,c,d){var s=0,r=A.i(t.N),q,p=this,o,n,m,l,k,j,i
var $async$b4=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:s=d==null?3:4
break
case 3:s=5
return A.b(p.co(),$async$b4)
case 5:d=f
case 4:o=b.a.ed(d,c,a)
s=6
return A.b(t.cI.b(o)?o:A.bM(o,t.T),$async$b4)
case 6:n=f
if(n!=null){q=n
s=1
break}o=b.a
s=7
return A.b(o.cq(a),$async$b4)
case 7:m=f
if(m==null)throw A.a(A.vl("Not logged in"))
l=A.vi("POST",A.dg(m.a).dz("sync/checkpoint-request"),a)
k=t.N
l.sj5(B.h.fR(A.bE(["client_id",d,"checkpoint_request_id",c],k,k),null))
p.eV(l,m)
k=l.r
k.l(0,"Accept","application/json")
k.l(0,"Content-Type","application/json")
i=A
s=9
return A.b(p.y.ao(l),$async$b4)
case 9:s=8
return A.b(i.j5(f),$async$b4)
case 8:j=f
k=j.b
s=k===401?10:11
break
case 10:s=12
return A.b(o.c8(!0,a),$async$b4)
case 12:case 11:if(k===404)throw A.a(B.b7)
if(k!==200)throw A.a(A.xv(j))
q=A.al(J.eV(J.eV(B.h.c5(A.wj(A.w6(j.e)).aI(j.w),null),"data"),"checkpoint_request_id"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$b4,r)},
bY(a,b){return this.lF(a,b)},
lF(a,b){var s=0,r=A.i(t.N),q,p=this,o,n,m,l,k
var $async$bY=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:m=t.J
s=3
return A.b(b.b1(new A.p2(a),m),$async$bY)
case 3:l=d
if(l==null)throw A.a(A.vl("Not logged in"))
k=A
s=4
return A.b(p.co(),$async$bY)
case 4:o=k.q(d)
s=5
return A.b(b.b1(new A.p3(p,A.dg(l.a).dz("write-checkpoint2.json?client_id="+o),l),t.b),$async$bY)
case 5:n=d
o=n.b
s=o===401?6:7
break
case 6:s=8
return A.b(b.b1(new A.p4(a),m),$async$bY)
case 8:case 7:if(o!==200)throw A.a(A.xv(n))
q=A.al(J.eV(J.eV(B.h.c5(A.wj(A.w6(n.e)).aI(n.w),null),"data"),"write_checkpoint"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bY,r)},
dY(a,b){return this.mx(a,b)},
mx(a,b){var s=0,r=A.i(t.U),q,p=this,o,n
var $async$dY=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=p.f
n.P(B.m,"Starting Rust sync iteration",null,null)
s=3
return A.b(new A.qt(p,a,b).kX(),$async$dY)
case 3:o=d
n.P(B.m,"Ending Rust sync iteration. Immediate restart: "+o.a,null,null)
q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dY,r)},
c0(a,b,c){return this.mc(a,b,c)},
mc(a,b,c){var s=0,r=A.i(t.n),q,p=this,o,n,m,l,k,j
var $async$c0=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:l=b.a
s=3
return A.b(l.cq(c),$async$c0)
case 3:k=e
if(k==null)throw A.a(A.vl("Not logged in"))
o=A.vi("POST",A.dg(k.a).dz("sync/stream"),c)
p.eV(o,k)
n=o.r
n.l(0,"Content-Type","application/json")
n.l(0,"Accept","application/vnd.powersync.bson-stream;q=0.9,application/x-ndjson;q=0.8")
o.sj5(B.h.fR(a,null))
s=4
return A.b(p.y.ao(o),$async$c0)
case 4:m=e
n=m.b
s=n===401?5:6
break
case 5:s=7
return A.b(l.c8(!0,c),$async$c0)
case 7:case 6:s=n!==200?8:9
break
case 8:j=A
s=10
return A.b(A.pf(m),$async$c0)
case 10:throw j.a(e)
case 9:q=m
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$c0,r)},
d1(a,b){return this.mp(a,b)},
mp(a,b){var s=0,r=A.i(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d
var $async$d1=A.d(function(c,a0){if(c===1){o.push(a0)
s=p}for(;;)switch(s){case 0:e={}
e.a=null
A:{k=n.d.w
if(k==null)k=B.r
j=k instanceof A.d7
i=j?k.a:null
if(j){e.a=i
break A}s=1
break}j=b.a.a,h=n.f,g=t.H
case 3:if(!((j.a&30)===0)){s=4
break}p=6
s=9
return A.b(b.b1(new A.p7(e,n,a),g),$async$d1)
case 9:p=2
s=8
break
case 6:p=5
d=o.pop()
m=A.E(d)
l=A.I(d)
if((j.a&30)!==0){s=1
break}h.P(B.i,"Error retrying checkpoint request",m,l)
s=10
return A.b(n.hX(b,e.a),$async$d1)
case 10:s=8
break
case 5:s=2
break
case 8:s=3
break
case 4:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$d1,r)},
bh(a,b,c){return this.mo(a,b,c)},
mo(a,b,c){var s=0,r=A.i(t.H),q,p=this,o,n,m,l,k,j,i
var $async$bh=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:k=new A.p5(p,c)
j=p.as
s=3
return A.b(j.hl(c,!1),$async$bh)
case 3:s=4
return A.b(k.$0(),$async$bh)
case 4:o=e
n=A.w7(b)
c.J(n.b)
s=5
return A.b(n.a,$async$bh)
case 5:i=o==null
if(i)e=i
else{s=6
break}s=7
break
case 6:i=o
s=8
return A.b(k.$0(),$async$bh)
case 8:e=!i.D(0,e)
case 7:if(e){s=1
break}k=p.z
m=k==null?null:k.r
k=!1
if(m!=null){l=m.a>=o.a
k=l}if(k){s=1
break}s=9
return A.b(j.hl(c,!1),$async$bh)
case 9:p.f.P(B.p,"Retry checkpoint request "+o.j(0),null,null)
s=10
return A.b(p.iB(c,a,v.G.String(o.a)),$async$bh)
case 10:case 1:return A.f(q,r)}})
return A.h($async$bh,r)},
hX(a,b){return a.b1(new A.p_(this,b),t.H)},
dP(a){return this.hX(a,null)},
e_(){var s=0,r=A.i(t.y),q,p=this
var $async$e_=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if(p.c.b!=null){q=!0
s=1
break}s=3
return A.b(A.ls(p.b),$async$e_)
case 3:q=!b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$e_,r)}}
A.pb.prototype={
$2(a,b){if(A.eJ(this.b,a))return
this.a.f.P(B.i,"Error in crud upload loop",a,b)},
$S:7}
A.p0.prototype={
$0(){return this.a.dY(this.b,this.c)},
$S:61}
A.p1.prototype={
$1(a){var s=this.a,r=s.d.d,q=A.w7(r==null?B.u:r),p=q.b
a.J(p)
s.as.c.a.J(p)
return q.a},
$S:18}
A.oZ.prototype={
$0(){return this.a.bW(this.b,this.c)},
$S:3}
A.pa.prototype={
$0(){var s,r,q=this.a,p=q.d.w
if(p==null)p=B.r
s=this.b
r=this.c
if(p instanceof A.fp)return q.bY(s,r)
else return q.iC(s,r)},
$S:63}
A.p9.prototype={
$1(a){return this.kf(a)},
kf(a){var s=0,r=A.i(t.N),q,p=this,o,n,m,l
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.a
s=3
return A.b(o.as.pc(a),$async$$1)
case 3:n=o
m=a
l=p.b
s=5
return A.b(A.vj(o.b,new A.p8(),a,t.N),$async$$1)
case 5:s=4
return A.b(n.iB(m,l,c),$async$$1)
case 4:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:64}
A.p8.prototype={
$1(a){return A.o5(a)},
$S:43}
A.p2.prototype={
$1(a){return this.a.a.cq(a)},
$S:26}
A.p3.prototype={
$1(a){return this.kd(a)},
kd(a){var s=0,r=A.i(t.b),q,p=this,o,n,m
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=A.vi("GET",p.b,a)
n=p.a
n.eV(o,p.c)
o.r.l(0,"Accept","application/json")
m=A
s=4
return A.b(n.y.ao(o),$async$$1)
case 4:s=3
return A.b(m.j5(c),$async$$1)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:66}
A.p4.prototype={
$1(a){return this.a.a.c8(!0,a)},
$S:26}
A.p7.prototype={
$1(a){return this.b.bh(this.c,this.a.a,a)},
$S:18}
A.p5.prototype={
$0(){return A.vj(this.a.b,new A.p6(),this.b,t.fo)},
$S:67}
A.p6.prototype={
$1(a){return this.ke(a)},
ke(a){var s=0,r=A.i(t.fo),q,p
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.d4(a,"current",null),$async$$1)
case 3:p=c
q=p==null?null:new A.cZ(v.G.BigInt(p))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:68}
A.p_.prototype={
$1(a){var s,r=this.b
if(r==null){r=this.a.d.d
if(r==null)r=B.u}s=A.w7(r)
a.J(s.b)
return s.a},
$S:18}
A.u9.prototype={
$0(){var s,r,q=this.b
if((q.a.a&30)===0){s=this.a
r=s.a
if(r!=null)r.u()
s.a=null
q.L()}},
$S:0}
A.qt.prototype={
i_(a){var s=this.a.e,r=A.a5(s).h("a8<1,a_<j,@>>")
s=A.ap(new A.a8(s,new A.qu(),r),r.h("X.E"))
return s},
kX(){return this.b.b1(new A.qA(this),t.U)},
dZ(){var s=0,r=A.i(t.ks),q,p=this,o,n,m,l
var $async$dZ=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=t.N
n=A.T(o,t.z)
m=p.a
l=m.d
n.l(0,"app_metadata",A.Bd(l))
n.l(0,"parameters",A.Be(l))
n.l(0,"schema",B.h.aI(m.a))
n.l(0,"include_defaults",l.f!==!1)
n.l(0,"active_streams",p.i_(m.e))
m=l.w
n.l(0,"checkpoint_mode",(m==null?B.r:m) instanceof A.d7?"requests":"legacy")
if(l.x)n.l(0,"diagnostics",A.T(o,t.X))
s=3
return A.b(p.bg("start",B.h.b8(n)),$async$dZ)
case 3:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dZ,r)},
d3(a,b){return this.my(a,b)},
my(a,b){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g
var $async$d3=A.d(function(c,d){if(c===1){p.push(d)
s=q}for(;;)switch(s){case 0:q=3
j=n.a
i=b.a.a
s=6
return A.b(j.b4(i,n.c,a.b,a.a),$async$d3)
case 6:m=d
s=7
return A.b(A.vj(j.b,new A.qz(m),i,t.H),$async$d3)
case 7:j=j.as
i=new A.ei(new A.fV(null))
j.a=i
j.b.q(0,i)
o.push(5)
s=4
break
case 3:q=2
g=p.pop()
l=A.E(g)
k=A.I(g)
if((b.a.a.a&30)===0){j=n.a
j.ch.q(0,new A.f1(l,k))
j=j.as
i=new A.ei(new A.ij(l,k))
j.a=i
j.b.q(0,i)}o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
b.j9()
b.aq()
s=o.pop()
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$d3,r)},
mh(a,b){return A.EW(this.a.c0(a,this.c,b),t.n).n4(new A.qy(),t.o)},
aN(a){return this.lK(a)},
lK(b5){var s=0,r=A.i(t.U),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4
var $async$aN=A.d(function(b6,b7){if(b6===1){o.push(b7)
s=p}for(;;)switch(s){case 0:b3=!1
p=4
a2=new A.bP(A.bd(b5,"stream",t.K))
p=7
a3=t.Y,a4=m.a,a5=a4.f,a6=m.b.a.a,a7=t.p,a4=a4.w
case 11:s=13
return A.b(a2.m(),$async$aN)
case 13:if(!b7){s=12
break}l=a2.gp()
if((a6.a&30)!==0){s=10
break}k=null
j=l
i=null
h=!1
s=j instanceof A.dK?15:16
break
case 15:s=17
return A.b(m.bg("connection",l.b),$async$aN)
case 17:k=b7
s=14
break
case 16:g=null
if(j instanceof A.cs){if(h)a8=i
else{h=!0
a9=j.a
i=a9
a8=a9}a8=a7.b(a8)
if(a8){if(h)b0=i
else{h=!0
a9=j.a
i=a9
b0=a9}g=a7.a(b0)}}else a8=!1
s=a8?18:19
break
case 18:if(!m.d){a8=a4.b
if(a8>=4)A.r(a4.ap())
if((a8&1)!==0)a4.a1(null)
else if((a8&3)===0){a8=a4.bX()
b0=new A.bx(null)
b1=a8.c
if(b1==null)a8.b=a8.c=b0
else{b1.sbs(b0)
a8.c=b0}}m.d=!0}s=20
return A.b(m.bg("line_binary",g),$async$aN)
case 20:k=b7
s=14
break
case 19:f=null
a8=j instanceof A.cs
if(a8){if(h)b0=i
else{h=!0
a9=j.a
i=a9
b0=a9}A.al(b0)
if(h)b0=i
else{h=!0
a9=j.a
i=a9
b0=a9}f=A.al(b0)}s=a8?21:22
break
case 21:if(!m.d){a8=a4.b
if(a8>=4)A.r(a4.ap())
if((a8&1)!==0)a4.a1(null)
else if((a8&3)===0){a8=a4.bX()
b0=new A.bx(null)
b1=a8.c
if(b1==null)a8.b=a8.c=b0
else{b1.sbs(b0)
a8.c=b0}}m.d=!0}s=23
return A.b(m.bg("line_text",f),$async$aN)
case 23:k=b7
s=14
break
case 22:s=j instanceof A.fU?24:25
break
case 24:s=26
return A.b(m.fm("completed_upload"),$async$aN)
case 26:k=b7
s=14
break
case 25:s=j instanceof A.fP?27:28
break
case 27:s=29
return A.b(m.fm("refreshed_token"),$async$aN)
case 29:k=b7
s=14
break
case 28:e=null
a8=j instanceof A.fg
if(a8)e=j.a
s=a8?30:31
break
case 30:s=32
return A.b(m.bg("update_subscriptions",B.h.b8(m.i_(e))),$async$aN)
case 32:k=b7
s=14
break
case 31:d=null
c=null
a8=j instanceof A.f1
if(a8){d=j.a
c=j.b}if(a8)A.il(d,c)
case 14:a8=J.Z(k)
case 33:if(!a8.m()){s=34
break}b=a8.gp()
a=b
if(a instanceof A.dN){a5.P(B.i,"Received EstablishSyncStream connection while already connected.",null,null)
s=33
break}a0=null
b0=a instanceof A.dI
if(b0)a0=a.a
if(b0){b3=a0
s=10
break}a1=null
b0=a3.b(a)
if(b0)a1=a
s=b0?35:36
break
case 35:s=37
return A.b(m.bZ(a1),$async$aN)
case 37:case 36:s=33
break
case 34:s=11
break
case 12:case 10:n.push(9)
s=8
break
case 7:n=[4]
case 8:p=4
s=38
return A.b(a2.u(),$async$aN)
case 38:s=n.pop()
break
case 9:p=2
s=6
break
case 4:p=3
b4=o.pop()
if(A.E(b4) instanceof A.ct){if((m.b.a.a.a&30)===0)throw b4}else throw b4
s=6
break
case 3:s=2
break
case 6:q=new A.ho(b3)
s=1
break
case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$aN,r)},
d4(){var s=0,r=A.i(t.H),q=this,p,o,n,m
var $async$d4=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:m=J
s=2
return A.b(q.fm("stop"),$async$d4)
case 2:p=m.Z(b),o=t.Y
case 3:if(!p.m()){s=4
break}n=p.gp()
s=o.b(n)?5:6
break
case 5:s=7
return A.b(q.bZ(n),$async$d4)
case 7:case 6:s=3
break
case 4:return A.f(null,r)}})
return A.h($async$d4,r)},
bg(a,b){return this.lR(a,b)},
fm(a){return this.bg(a,null)},
lR(a,b){var s=0,r=A.i(t.ks),q,p=this,o,n,m,l
var $async$bg=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=J
m=t.j
l=B.h
s=3
return A.b(A.lp(p.a.b,a,b),$async$bg)
case 3:o=n.zW(m.a(l.aI(d)),t.f)
q=new A.a8(o,A.ED(),o.$ti.h("a8<y.E,as>"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bg,r)},
bZ(a){return this.lJ(a)},
lJ(a){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j,i
var $async$bZ=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=a instanceof A.fr
if(p){o=a.a
n=a.b}else{o=null
n=null}if(p){A:{if("DEBUG"===o){p=B.p
break A}if("INFO"===o){p=B.m
break A}p=B.i
break A}q.a.f.oz(p,n)
s=2
break}p=a instanceof A.fS
m=p?a.a:null
if(p){p=q.a
p.z=m
p.Q.q(0,new A.aL(m,null,null,null))
s=2
break}p={}
p.a=null
l=a instanceof A.fd
if(l)p.a=a.a
s=l?3:4
break
case 3:k=q.b.b1(new A.qv(p,q),t.J)
s=p.a?5:7
break
case 5:s=8
return A.b(k,$async$bZ)
case 8:s=6
break
case 7:k.bb(new A.qw(q),new A.qx(q),t.P)
case 6:s=2
break
case 4:if(a instanceof A.f9){q.a.Q.q(0,new A.aL(null,null,B.w,null))
s=2
break}s=a instanceof A.f0?9:10
break
case 9:p=q.a
s=11
return A.b(p.e_(),$async$bZ)
case 11:if(!c){p.f.P(B.i,u.l,null,null)
p.Q.q(0,new A.aL(null,null,new A.aX(u.l),null))}s=2
break
case 10:p=a instanceof A.fh
j=p?a.a:null
if(p){q.a.x.q(0,B.h.b8(j))
s=2
break}p=a instanceof A.fQ
i=p?a.a:null
if(p)q.a.f.P(B.i,"Unknown instruction: "+A.q(i),null,null)
case 2:return A.f(null,r)}})
return A.h($async$bZ,r)}}
A.qu.prototype={
$1(a){return A.bE(["name",a.a,"params",B.h.aI(a.b)],t.N,t.z)},
$S:69}
A.qA.prototype={
$1(a){return this.kl(a)},
kl(b5){var s=0,r=A.i(t.U),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4
var $async$$1=A.d(function(b6,b7){if(b6===1){o.push(b7)
s=p}for(;;)switch(s){case 0:b0=null
b1=null
p=4
b3=e=m.a
b4=J
s=7
return A.b(e.dZ(),$async$$1)
case 7:b3,d=b4.Z(b7),c=t.Y,b=e.a.ch,a=A.p(b).h("aq<1>"),a0=t.o,a1=t.fu,a2=t.D,a3=t.h,a4=t.A
case 8:if(!d.m()){s=9
break}l=d.gp()
k=l
j=null
i=null
a5=k instanceof A.dN
if(a5){j=k.a
i=k.b}if(a5){b0=A.z3(A.u([e.mh(j,b5),new A.aq(b,a)],a1),a0)
if(i!=null){a5=$.m
a6=new A.aa(new A.l(a5,a2),a3)
a7=A.bs(a4)
a8=new A.hQ(a6,a7,new A.aa(new A.l(a5,a2),a3))
a7.q(0,a6)
b1=a8
h=a8
e.d3(i,h)}s=8
break}if(k instanceof A.dI){q=B.ai
n=[1]
s=5
break}g=null
a5=c.b(k)
if(a5)g=k
s=a5?10:11
break
case 10:s=12
return A.b(e.bZ(g),$async$$1)
case 12:case 11:s=8
break
case 9:if(b0==null){q=B.ai
n=[1]
s=5
break}s=13
return A.b(e.aN(b0),$async$$1)
case 13:e=b7
q=e
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:p=3
b2=o.pop()
f=A.E(b2)
e=m.a
if(!A.eJ(e.b,f))e.a.Q.q(0,new A.aL(null,null,f,null))
throw b2
n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
e=b1
e=e==null?null:e.aq()
s=14
return A.b(e instanceof A.l?e:A.bM(e,t.H),$async$$1)
case 14:e=m.a
d=e.a.as
d.c=new A.aa(new A.l($.m,t.D),t.h)
d.a=B.D
d.b.q(0,B.D)
s=15
return A.b(e.d4(),$async$$1)
case 15:s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$1,r)},
$S:70}
A.qz.prototype={
$1(a){return A.d4(a,"seed",this.a)},
$S:71}
A.qy.prototype={
$1(a){return this.kk(a)},
kk(a){var $async$$1=A.d(function(b,c){switch(b){case 2:n=q
s=n.pop()
break
case 1:o.push(c)
s=p}for(;;)switch(s){case 0:s=3
q=[1]
return A.kK(A.xV(B.b9),$async$$1,r)
case 3:m=a.w
if(a.e.i(0,"content-type")==="application/vnd.powersync.bson-stream")m=new A.c8(A.EX(),m,t.jB)
else m=B.aY.bj(B.aF.bj(m))
s=4
q=[1]
return A.kK(A.Ca(new A.aM(A.EY(),m,m.$ti.h("aM<D.T,aS>"))),$async$$1,r)
case 4:s=5
q=[1]
return A.kK(A.xV(B.ba),$async$$1,r)
case 5:case 1:return A.kK(null,0,r)
case 2:return A.kK(o.at(-1),1,r)}})
var s=0,r=A.Dr($async$$1,t.o),q,p=2,o=[],n=[],m
return A.DN(r)},
$S:72}
A.qv.prototype={
$1(a){return this.b.c.a.c8(this.a.a,a)},
$S:26}
A.qw.prototype={
$1(a){var s=this.a
if((s.b.a.a.a&30)===0)s.a.ch.q(0,B.b1)},
$S:73}
A.qx.prototype={
$2(a,b){var s=this.a
if(!A.eJ(s.b,a))s.a.f.P(B.i,"Could not prefetch credentials",a,b)},
$S:7}
A.dK.prototype={
aF(){return"ConnectionEvent."+this.b},
$iaS:1}
A.cs.prototype={$iaS:1}
A.fU.prototype={$iaS:1}
A.fP.prototype={$iaS:1}
A.fg.prototype={$iaS:1}
A.f1.prototype={$iaS:1}
A.e2.prototype={
ao(a){return this.kC(a)},
kC(a){var s=0,r=A.i(t.n),q,p=this,o,n,m,l,k,j
var $async$ao=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:a.hx()
k=t.a
j=B.f
s=3
return A.b(new A.cP(A.xs(a.y,t.f4)).hh(),$async$ao)
case 3:o=k.a(j.gar(c))
n=p.b++
m=p.a.dJ({r:0,i:n,u:a.b.j(0),m:a.a,h:B.h.b8(a.r),b:o})
a.cx.J(new A.or(p,n))
s=4
return A.b(m,$async$ao)
case 4:l=c
n=A.Cr(p,n).c
q=A.Bq(new A.a4(n,A.p(n).h("a4<1>")),l.s,null,A.AE(l),!1,!0,null,a)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ao,r)},
hu(a,b){this.a.y.postMessage({type:"abortHttpRequest",payload:{r:b,i:a}})}}
A.or.prototype={
$0(){return this.a.hu(this.b,!1)},
$S:0}
A.kj.prototype={
l9(a,b){var s=this.c
s.f=s.d=this.gnR()
s.r=new A.td(this)},
ef(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h
var $async$ef=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:n.d=!0
q=3
s=6
return A.b(n.a.a.ew(n.b),$async$ef)
case 6:m=b
j=n.c
if(m!=null)j.q(0,A.aV(m,0,null))
else j.n()
o.push(5)
s=4
break
case 3:q=2
h=p.pop()
l=A.E(h)
k=A.I(h)
j=n.c
j.ag(l,k)
j.n()
o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
n.d=!1
n.jk()
s=o.pop()
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$ef,r)},
jk(){var s,r,q=!1
if(!this.d){s=this.c
r=s.b
if((r&1)!==0)if((r&4)===0){q=s.ga6().e
q=(q&4)===0}}if(q)this.ef()}}
A.td.prototype={
$0(){var s=this.a
return s.a.hu(s.b,!0)},
$S:0}
A.vB.prototype={
$2(a,b){this.a.r.l(0,a,b)
return b},
$S:45}
A.vV.prototype={
n(){var s,r=this
if(!r.a){r.a=!0
s=r.c
if(s!=null)s.u()
r.iY(!1)}},
iY(a){var s,r=this.b
if((r.a.a&30)===0){if(a){s=this.c
if(s!=null)s.u()}r.L()}}}
A.pn.prototype={
mj(a,b,c,d,e){var s=this.a.cD(a,new A.po(a))
s.oS(e,b,c,d)
return s}}
A.po.prototype={
$0(){return A.Bv(this.a)},
$S:74}
A.ci.prototype={
kY(a,b){var s=this,r=A.BI(a,new A.lY(s))
s.a=r
r.c.a.J(s.goC())
s.d=$.cL().fc().O(new A.lZ(s))},
h6(){var s=this,r=s.d
if(r!=null)r.u()
r=s.c
if(r!=null)r.e.q(0,new A.hs(s))
s.c=null}}
A.lY.prototype={
$3(a,b,c){return this.k5(a,b,c)},
k5(a3,a4,a5){var s=0,r=A.i(t.k0),q,p=this,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
var $async$$3=A.d(function(a6,a7){if(a6===1)return A.e(a7,r)
for(;;)switch(s){case 0:case 3:switch(a3.a){case 1:s=5
break
case 3:s=6
break
case 2:s=7
break
case 7:s=8
break
default:s=9
break}break
case 5:A.S(a4)
o=p.a
n=o.a
n===$&&A.L()
m=a4.lockName
if(!n.f){n.f=!0
A.qd(m).ox(n.gaG(),t.H)}n=A.mS(0,a4.crudThrottleTimeMs)
l=a4.retryDelayMs
A:{if(l==null){m=null
break A}m=A.mS(0,l)
break A}k=a4.syncParamsEncoded
B:{if(k==null){j=null
break B}j=t.f.a(B.h.c5(k,null))
break B}i=a4.appMetadataEncoded
C:{if(i==null){h=null
break C}h=t.N
h=A.x3(t.ea.a(B.h.c5(i,null)),h,h)
break C}g=J.A(a4.customHttpClient,!0)?new A.lX(o):null
f=a4.checkpointModeRequestsDelay
D:{if(f==null){e=B.r
break D}e=new A.d7(A.mS(f,0))
break D}d=a4.diagnostics
if(d==null)d=!1
c=a4.hasAuthenticator
if(c==null)c=!0
b=a4.hasUploader
if(b==null)b=!0
o.e=c?new A.oh(o.a):null
o.f=b?new A.j4(o.a):null
a=a4.databaseName
a0=a4.schemaJson
a1=a4.subscriptions
a1=a1==null?null:A.xC(a1)
if(a1==null)a1=B.bv
o.c=o.b.mj(a,new A.fM(h,j,n,m,B.ap,null,g,e,d),a0,a1,o)
q=new A.Q({},null)
s=1
break
case 6:o=p.a
n=o.c
if(n!=null)n.e.q(0,new A.h7(o))
o.c=null
q=new A.Q({},null)
s=1
break
case 7:o=p.a
n=o.c
if(n!=null){m=A.xC(A.S(a4))
n.e.q(0,new A.h4(o,m))}q=new A.Q({},null)
s=1
break
case 8:a2=A
s=10
return A.b(p.a.c.f.ey(),$async$$3)
case 10:q=new a2.Q(a7.a,null)
s=1
break
case 9:throw A.a(A.z("Unexpected message type "+a3.j(0)))
case 4:case 1:return A.f(q,r)}})
return A.h($async$$3,r)},
$S:75}
A.lX.prototype={
$0(){var s=this.a.a
s===$&&A.L()
return new A.e2(s)},
$S:76}
A.lZ.prototype={
$1(a){var s="["+a.d+"] "+a.a.a+": "+a.e.j(0)+": "+a.b,r=a.r
if(r!=null)s=s+"\n"+A.q(r)
r=a.w
if(r!=null)s=s+"\n"+r.j(0)
r=this.a.a
r===$&&A.L()
r.y.postMessage({type:"logEvent",payload:s.charCodeAt(0)==0?s:s})},
$S:52}
A.e9.prototype={
l2(a){var s=this.e
this.d.q(0,new A.a4(s,A.p(s).h("a4<1>")))
A.AA(new A.pl(this),t.P)},
cj(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$cj=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=$.cL()
n.P(B.m,"Remote database closed, finding a new client",null,null)
p=q.f
p=p==null?null:p.aq()
s=2
return A.b(p instanceof A.l?p:A.bM(p,t.H),$async$cj)
case 2:q.f=null
s=3
return A.b(q.f0(),$async$cj)
case 3:o=b
s=o==null?4:6
break
case 4:n.P(B.m,"No client remains",null,null)
s=5
break
case 6:s=7
return A.b(q.c1(o),$async$cj)
case 7:case 5:return A.f(null,r)}})
return A.h($async$cj,r)},
jM(){var s,r,q=this,p=q.y,o=A.AR(p,A.a5(p).c)
p=q.x
s=A.wZ(new A.bX(p,A.p(p).h("bX<2>")),t.E)
if(!B.b_.bG(o,s)){$.cL().P(B.m,"Subscriptions across tabs have changed, checking whether a reconnect is necessary",null,null)
p=A.ap(s,A.p(s).c)
q.y=p
r=q.f
if(r!=null){r.e=p
r=r.ch
if(r.d!=null)r.q(0,new A.fg(p))}}},
f0(){return this.ll()},
ll(){var s=0,r=A.i(t.gO),q,p=this,o,n,m,l,k,j,i,h,g
var $async$f0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:j={}
i=p.x
h=A.p(i).h("b5<1>")
g=A.ap(new A.b5(i,h),h.h("n.E"))
i=g.length
if(i===0){q=null
s=1
break}h=new A.l($.m,t.iB)
o=new A.aa(h,t.if)
j.a=i
for(n=t.P,m=0;m<g.length;g.length===i||(0,A.a6)(g),++m){l=g[m]
k=l.a
k===$&&A.L()
k.ev().aK(new A.pg(j,o,l),n).p_(B.u,new A.ph(j,l,o))}q=h
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$f0,r)},
c1(a){return this.mr(a)},
mr(a6){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5
var $async$c1=A.d(function(a7,a8){if(a7===1)return A.e(a8,r)
for(;;)switch(s){case 0:a5=$.cL()
a5.P(B.m,"Sync setup: Requesting database",null,null)
p=a6.a
p===$&&A.L()
s=2
return A.b(p.ez(),$async$c1)
case 2:o=a8
a5.P(B.m,"Sync setup: Connecting to endpoint",null,null)
p=o.databasePort
s=3
return A.b(A.qh(new A.kg(o.databaseName,p,o.lockName)),$async$c1)
case 3:n=a8
a5.P(B.m,"Sync setup: Has database, starting sync!",null,null)
q.w=a6
p=t.P
n.a.c.a.aK(new A.pi(a6),p)
m=A.u(["ps_crud"],t.s)
A.EQ(new A.dp(t.hV))
l=n.d
k=A.Bz(m).bj(l)
l=q.b.c
if(l==null)l=B.G
j=A.BA(k,l,new A.K(B.bF))
l=q.x
l=A.wZ(new A.bX(l,A.p(l).h("bX<2>")),t.E)
l=A.ap(l,A.p(l).c)
q.y=l
i=q.c
h=a6.e
g=a6.f
f=q.b
e=q.a
p=A.bI(null,null,null,null,!1,p)
d=t.N
c=A.c3(!1,d)
b=A.c3(!1,t.k4)
a=A.c3(!1,t.hi)
a0=$.m
a1=A.c3(!1,t.o)
a2=f.r
a2=a2==null?null:a2.$0()
if(a2==null){a6=$.m.i(0,B.bH)
a2=a6==null?null:t.dF.a(a6).$0()
if(a2==null)a2=new A.i4(A.u([],t.kG))}a3=A.qd("sync-"+e)
e=A.qd("crud-"+e)
d=A.bE(["X-User-Agent","powersync-dart-core/2.6.1 Dart (flutter-web)"],d,d)
a4=new A.oY(i,n,new A.nF(h,g),f,l,a5,j,p,c,a2,b,new A.lI(B.D,a,new A.aa(new A.l(a0,t.D),t.h)),a3,e,a1,d)
q.f=a4
new A.aq(b,A.p(b).h("aq<1>")).O(new A.pj(q))
new A.aq(c,A.p(c).h("aq<1>")).O(new A.pk(q))
a4.cR()
return A.f(null,r)}})
return A.h($async$c1,r)},
oS(a,b,c,d){var s,r,q,p=a.e!=null,o=a.f!=null
for(s=this.x,s=new A.d0(s,s.r,s.e);s.m();){r=s.d
if(r===a)continue
q=r.e
r=r.f
if(p!==(q!=null)||o!==(r!=null))throw A.a(A.z("Different tabs connecting in different modes (download-only / upload-only / full) is not supported"))}this.e.q(0,new A.fZ(a,b,c,d))}}
A.pl.prototype={
$0(){var s=0,r=A.i(t.P),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8
var $async$$0=A.d(function(c9,d0){if(c9===1){p.push(d0)
s=q}for(;;)switch(s){case 0:c6=n.a
c7=c6.d.a
c7===$&&A.L()
c7=new A.bP(A.bd(new A.a4(c7,A.p(c7).h("a4<1>")),"stream",t.K))
q=2
a6=c6.x,a7=t.D,a8=c6.r
case 5:s=7
return A.b(c7.m(),$async$$0)
case 7:if(!d0){s=6
break}m=c7.gp()
q=9
l=m
k=null
j=!1
i=null
h=!1
g=null
f=null
e=null
d=null
a9=l instanceof A.fZ
if(a9){if(j)b0=k
else{j=!0
b1=l.a
k=b1
b0=b1}g=b0
f=l.b
e=l.c
if(h)b2=i
else{h=!0
b3=l.d
i=b3
b2=b3}d=b2}s=a9?13:14
break
case 13:a6.l(0,g,d)
c=null
b=null
a9=c6.b
b4=f
b5=b4.c
if(b5==null){b5=a9.c
if(b5==null)b5=B.G}b6=b4.d
if(b6==null){b6=a9.d
if(b6==null)b6=B.u}b7=b4.b
if(b7==null){b7=a9.b
if(b7==null)b7=B.K}b8=b4.e
b9=b4.f
if(b9==null)b9=a9.f!==!1
c0=b4.a
if(c0==null){c0=a9.a
if(c0==null)c0=B.L}c1=b4.r
if(c1==null)c1=a9.r
c2=b4.w
if(c2==null){c2=a9.w
if(c2==null)c2=B.r}b4=b4.x
c3=a9.b
c4=!0
if(B.y.bG(b7,c3==null?B.K:c3)){c3=a9.c
if(b5.D(0,c3==null?B.G:c3)){c3=a9.d
if(b6.D(0,c3==null?B.u:c3))if(b8===a9.e)if(b9===(a9.f!==!1)){c3=a9.a
if(B.y.bG(c0,c3==null?B.L:c3)){c3=a9.w
a9=!c2.D(0,c3==null?B.r:c3)||b4!==a9.x}else a9=c4}else a9=c4
else a9=c4
else a9=c4
c4=a9}}a=new A.Q(new A.fM(c0,b7,b5,b6,b8,b9,c1,c2,b4),c4)
c=a.a
b=a.b
c6.b=c
c6.c=e
a9=c6.f
s=a9==null?15:17
break
case 15:s=18
return A.b(c6.c1(g),$async$$0)
case 18:s=16
break
case 17:s=b?19:21
break
case 19:a9.aq()
c6.f=null
s=22
return A.b(c6.c1(g),$async$$0)
case 22:s=20
break
case 21:c6.jM()
case 20:case 16:a9=g.a
a9===$&&A.L()
a9.y.postMessage({type:"notifySyncStatus",payload:a8})
s=12
break
case 14:a0=null
a9=l instanceof A.hs
if(a9){if(j)b0=k
else{j=!0
b1=l.a
k=b1
b0=b1}a0=b0}s=a9?23:24
break
case 23:a6.H(0,a0)
s=a6.a===0?25:27
break
case 25:a9=c6.f
a9=a9==null?null:a9.aq()
if(!(a9 instanceof A.l)){b4=new A.l($.m,a7)
b4.a=8
b4.c=a9
a9=b4}s=28
return A.b(a9,$async$$0)
case 28:c6.f=null
s=26
break
case 27:s=J.A(a0,c6.w)?29:30
break
case 29:s=31
return A.b(c6.cj(),$async$$0)
case 31:case 30:case 26:s=12
break
case 24:a1=null
a9=l instanceof A.h7
if(a9){if(j)b0=k
else{j=!0
b1=l.a
k=b1
b0=b1}a1=b0}s=a9?32:33
break
case 32:a6.H(0,a1)
a9=c6.f
a9=a9==null?null:a9.aq()
if(!(a9 instanceof A.l)){b4=new A.l($.m,a7)
b4.a=8
b4.c=a9
a9=b4}s=34
return A.b(a9,$async$$0)
case 34:c6.f=null
s=12
break
case 33:a2=null
a3=null
a9=l instanceof A.h4
if(a9){if(j)b0=k
else{j=!0
b1=l.a
k=b1
b0=b1}a2=b0
if(h)b2=i
else{h=!0
b3=l.b
i=b3
b2=b3}a3=b2}if(a9){a6.l(0,a2,a3)
c6.jM()}case 12:q=2
s=11
break
case 9:q=8
c8=p.pop()
a4=A.E(c8)
a5=A.I(c8)
a9=$.cL()
b4=A.q(m)
a9.P(B.i,"Error handling "+b4,a4,a5)
s=11
break
case 8:s=2
break
case 11:s=5
break
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
s=35
return A.b(c7.u(),$async$$0)
case 35:s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:51}
A.pg.prototype={
$1(a){var s;--this.a.a
s=this.b
if((s.a.a&30)===0)s.T(this.c)},
$S:9}
A.ph.prototype={
$0(){var s=this,r=s.a;--r.a
s.b.h6()
if(r.a===0&&(s.c.a.a&30)===0)s.c.T(null)},
$S:1}
A.pi.prototype={
$1(a){$.cL().P(B.p,"Detected closed client",null,null)
this.a.h6()},
$S:9}
A.pj.prototype={
$1(a){var s,r,q,p,o,n,m=this
$.cL().P(B.p,"Broadcasting status update: "+a.j(0),null,null)
s={}
r=a.a
if(r!=null){q=B.h.b8(r.a)
m.a.r.core=q
s.core=q}p=a.b
if(p!=null){m.a.r.uploading=p
s.uploading=p}o=a.c
if(o!=null){o=A.xp(o)
m.a.r.downloadError=o
s.downloadError=o}o=a.d
if(o!=null){o=A.xp(o)
m.a.r.uploadError=o
s.uploadError=o}for(o=m.a.x,o=new A.d0(o,o.r,o.e);o.m();){n=o.d.a
n===$&&A.L()
n.y.postMessage({type:"notifySyncStatus",payload:s})}},
$S:79}
A.pk.prototype={
$1(a){var s,r
$.cL().P(B.p,"Broadcasting diagnostic event: "+a,null,null)
for(s=this.a.x,s=new A.d0(s,s.r,s.e);s.m();){r=s.d.a
r===$&&A.L()
r.y.postMessage({type:"handleDiagnostics",payload:a})}},
$S:80}
A.fZ.prototype={$ibO:1}
A.hs.prototype={$ibO:1}
A.h7.prototype={$ibO:1}
A.h4.prototype={$ibO:1}
A.af.prototype={
aF(){return"SyncWorkerMessageType."+this.b}}
A.pM.prototype={
$1(a){var s,r,q,p,o
t.c.a(a)
s=t.k.b(a)?a:new A.ag(a,A.a5(a).h("ag<1,j>"))
r=J.ab(s)
q=r.gk(s)===2
if(q){p=r.i(s,0)
o=r.i(s,1)}else{p=null
o=null}if(!q)throw A.a(A.z("Pattern matching error"))
return new A.kd(p,o)},
$S:81}
A.jC.prototype={
l4(a,b,c,d,e){var s=this,r=s.y
r.start()
s.w=null
s.r=A.aD(r,"message",new A.qo(s),!1,t.m)},
c2(a,b){return this.mt(a,b)},
mt(a,b){var s=0,r=A.i(t.H),q=1,p=[],o=this,n,m,l,k,j,i,h,g,f,e
var $async$c2=A.d(function(c,d){if(c===1){p.push(d)
s=q}for(;;)switch(s){case 0:q=3
n=null
m=null
g=b.$0()
s=6
return A.b(t.nK.b(g)?g:A.bM(g,t.iu),$async$c2)
case 6:l=d
n=l.a
m=l.b
k={type:"okResponse",payload:{requestId:a,payload:n}}
g=o.y
if(m!=null)g.postMessage(k,m)
else g.postMessage(k)
q=1
s=5
break
case 3:q=2
e=p.pop()
j=A.E(e)
i=null
h=j
A:{if(h instanceof A.ct){i=1
break A}if(h instanceof A.bC){i=2
break A}i=0
break A}o.y.postMessage({type:"errorResponse",payload:{requestId:a,recognizedType:i,errorMessage:J.be(j)}})
s=5
break
case 2:s=1
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$c2,r)},
dT(){var s,r,q=this
if(q.e||(q.c.a.a&30)!==0)throw A.a(A.z("Channel has error, cannot send new requests"))
s=q.d++
r=new A.l($.m,t.ny)
q.a.l(0,s,new A.N(r,t.gW))
return new A.Q(s,r)},
dU(a,b){var s=this.dT(),r=s.a
this.y.postMessage({type:a.b,payload:r})
this.i6(r,b)
return s.b},
il(a){return this.dU(a,null)},
i6(a,b){if(b!=null)b.aK(new A.qn(this,a),t.P)},
ev(){var s=0,r=A.i(t.H),q=this
var $async$ev=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=2
return A.b(q.il(B.O),$async$ev)
case 2:return A.f(null,r)}})
return A.h($async$ev,r)},
ez(){var s=0,r=A.i(t.m),q,p=this,o
var $async$ez=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=A
s=3
return A.b(p.il(B.Q),$async$ez)
case 3:q=o.S(b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ez,r)},
cq(a){return this.nd(a)},
nd(a){var s=0,r=A.i(t.J),q,p=this,o,n
var $async$cq=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:n=A
s=3
return A.b(p.dU(B.T,a),$async$cq)
case 3:o=n.w5(c)
q=o==null?null:A.xo(o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cq,r)},
c8(a,b){return this.oN(a,b)},
oN(a,b){var s=0,r=A.i(t.J),q,p=this,o,n
var $async$c8=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=A
s=3
return A.b(p.dU(a?B.S:B.P,b),$async$c8)
case 3:o=n.w5(d)
q=o==null?null:A.xo(o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$c8,r)},
eB(a){return this.pb(a)},
pb(a){var s=0,r=A.i(t.H),q=this
var $async$eB=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=2
return A.b(q.dU(B.R,a),$async$eB)
case 2:return A.f(null,r)}})
return A.h($async$eB,r)},
ed(a,b,c){return this.ne(a,b,c)},
ne(a,b,c){var s=0,r=A.i(t.T),q,p=this,o,n,m,l
var $async$ed=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:n=p.dT()
m=n.a
p.y.postMessage({type:"customCheckpointRequest",payload:{req:m,clientId:a,requestId:b}})
p.i6(m,c)
l=A
s=3
return A.b(n.b,$async$ed)
case 3:o=l.kJ(e)
q=o==null?null:o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ed,r)},
dJ(a){return this.kD(a)},
kD(a){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$dJ=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.dT()
a.r=o.a
p.y.postMessage({type:"sendHttpRequest",payload:a},[a.b])
n=A
s=3
return A.b(o.b,$async$dJ)
case 3:q=n.S(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dJ,r)},
ew(a){return this.oP(a)},
oP(a){var s=0,r=A.i(t.aC),q,p=this,o,n
var $async$ew=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.dT()
p.y.postMessage({type:"readResponseChunk",payload:{r:o.a,i:a}})
n=t.aC
s=3
return A.b(o.b,$async$ew)
case 3:q=n.a(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ew,r)},
n(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=q.c
if((n.a.a&30)===0){p=q.r
if(p!=null)p.u()
q.y.close()
p=q.at
if(p!=null)p.q4()
for(p=q.a,p=new A.b6(p,p.r,p.e);p.m();)p.d.ab(B.aO)
for(p=q.b,o=new A.b6(p,p.r,p.e);o.m();)o.d.L()
p.au(0)
n.L()}return A.f(null,r)}})
return A.h($async$n,r)}}
A.qo.prototype={
$1(a){return this.kj(a)},
kj(a1){var s=0,r=A.i(t.H),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$$1=A.d(function(a2,a3){if(a2===1){o.push(a3)
s=p}for(;;)A:switch(s){case 0:c=A.S(a1.data)
b=A.mV(B.bq,c.type)
a=m.a
a0=a.as
a0.P(B.p,"[in] "+A.q(b),null,null)
l=null
switch(b){case B.O:l=A.R(A.bA(c.payload))
q=a.c2(l,new A.qj())
s=1
break A
case B.aq:l=A.S(c.payload).requestId
break
case B.aA:l=A.S(c.payload).requestId
break
case B.Q:case B.aB:case B.T:case B.S:case B.P:case B.R:case B.aD:l=A.R(A.bA(c.payload))
break
case B.aC:l=A.R(A.S(c.payload).req)
break
case B.av:h=A.S(c.payload)
q=a.c2(h.r,new A.qk(a,h))
s=1
break A
case B.aw:g=A.S(c.payload)
a0=g.i
f=g.r
a0=a.at.b.H(0,a0)
if(a0!=null)a0.iY(f)
s=1
break A
case B.ax:h=A.S(c.payload)
q=a.c2(h.r,new A.ql(a,h))
s=1
break A
case B.ay:g=A.S(c.payload)
a.a.H(0,g.requestId).T(g.payload)
s=1
break A
case B.az:g=A.S(c.payload)
e=g.recognizedType
if(e==null)e=0
B:{if(1===e){a0=new A.ct("Request aborted by `abortTrigger`",null)
break B}if(2===e){a0=new A.bC("aborted over web channel")
break B}a0=g.errorMessage
break B}a.a.H(0,g.requestId).ab(a0)
s=1
break A
case B.as:case B.at:a.Q.q(0,new A.Q(b,c.payload))
s=1
break A
case B.au:a0.P(B.m,"[Sync Worker]: "+A.al(c.payload),null,null)
s=1
break A
case B.ar:a=a.b.H(0,A.R(A.bA(c.payload)))
if(a!=null)a.L()
s=1
break A}a0=a.b
f=l
d=new A.aa(new A.l($.m,t.D),t.h)
a0.l(0,f,d)
k=d
p=3
s=6
return A.b(a.c2(l,new A.qm(a,b,c,k)),$async$$1)
case 6:n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
j=a0.H(0,l)
i=null
if(j!=null){i=j
i.L()}s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$1,r)},
$S:82}
A.qj.prototype={
$0(){var s=0,r=A.i(t.lg),q
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q=B.aj
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:83}
A.qk.prototype={
$0(){var s=0,r=A.i(t.iS),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=A
s=3
return A.b(p.a.at.q5(p.b),$async$$0)
case 3:q=new o.Q(b,null)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:84}
A.ql.prototype={
$0(){var s=0,r=A.i(t.jc),q,p=this,o,n
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=3
return A.b(p.a.at.q7(p.b.i),$async$$0)
case 3:n=b
A:{if(n==null){o=B.aj
break A}o=new A.Q(n,[n])
break A}q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:85}
A.qm.prototype={
$0(){var s=this
return s.a.z.$3(s.b,s.c.payload,s.d.a)},
$S:86}
A.qn.prototype={
$1(a){var s=this.a,r=this.b
if(s.a.E(r)&&(s.c.a.a&30)===0)s.y.postMessage({type:"abortRequest",payload:r})},
$S:9}
A.oh.prototype={}
A.j4.prototype={
pa(a){return this.a.eB(a)}}
A.i8.prototype={
j(a){return"Worker communication channel closed"},
$iO:1}
A.uT.prototype={
$1(a){var s=A.S(a.data)
if(s.isForSyncWorker)A.Aj(A.S(s.message),this.a)
else this.b.q(0,new v.G.MessageEvent("message",{data:s.message}))},
$S:2}
A.uU.prototype={
$1(a){a.start()
A.aD(a,"message",this.a,!1,t.m)},
$S:2}
A.uS.prototype={
$1(a){var s,r=a.ports
r=J.Z(t.ip.b(r)?r:new A.ag(r,A.a5(r).h("ag<1,v>")))
s=this.a
while(r.m())s.$1(r.gp())},
$S:2}
A.rs.prototype={
n(){if($.zF())v.G.close()},
gna(){return this.a},
goi(){return this.b}}
A.o4.prototype={}
A.o6.prototype={
eP(){return this.a.eP()}}
A.oB.prototype={
gk(a){return this.c.length},
gor(){return this.b.length},
l_(a,b){var s,r,q,p,o,n,m,l,k
for(s=this.c,r=s.length,q=a.a,p=s.$flags|0,o=q.length,n=this.b,m=0;m<r;++m){l=q.charCodeAt(m)
p&2&&A.C(s)
s[m]=l
if(l===13){k=m+1
if(k>=o||q.charCodeAt(k)!==10)l=10}if(l===10)n.push(m+1)}},
cK(a){var s,r=this
if(a<0)throw A.a(A.az("Offset may not be negative, was "+a+"."))
else if(a>r.c.length)throw A.a(A.az("Offset "+a+u.D+r.gk(0)+"."))
s=r.b
if(a<B.c.gai(s))return-1
if(a>=B.c.gaQ(s))return s.length-1
if(r.lS(a)){s=r.d
s.toString
return s}return r.d=r.lh(a)-1},
lS(a){var s,r,q=this.d
if(q==null)return!1
s=this.b
if(a<s[q])return!1
r=s.length
if(q>=r-1||a<s[q+1])return!0
if(q>=r-2||a<s[q+2]){this.d=q+1
return!0}return!1},
lh(a){var s,r,q=this.b,p=q.length-1
for(s=0;s<p;){r=s+B.b.Y(p-s,2)
if(q[r]>a)p=r
else s=r+1}return p},
eN(a){var s,r,q=this
if(a<0)throw A.a(A.az("Offset may not be negative, was "+a+"."))
else if(a>q.c.length)throw A.a(A.az("Offset "+a+" must be not be greater than the number of characters in the file, "+q.gk(0)+"."))
s=q.cK(a)
r=q.b[s]
if(r>a)throw A.a(A.az("Line "+s+" comes after offset "+a+"."))
return a-r},
dG(a){var s,r,q,p
if(a<0)throw A.a(A.az("Line may not be negative, was "+a+"."))
else{s=this.b
r=s.length
if(a>=r)throw A.a(A.az("Line "+a+" must be less than the number of lines in the file, "+this.gor()+"."))}q=s[a]
if(q<=this.c.length){p=a+1
s=p<r&&q>=s[p]}else s=!0
if(s)throw A.a(A.az("Line "+a+" doesn't have 0 columns."))
return q}}
A.ir.prototype={
gM(){return this.a.a},
gW(){return this.a.cK(this.b)},
ga7(){return this.a.eN(this.b)},
ga8(){return this.b}}
A.er.prototype={
gM(){return this.a.a},
gk(a){return this.c-this.b},
gG(){return A.vo(this.a,this.b)},
gC(){return A.vo(this.a,this.c)},
gah(){return A.bJ(B.M.bS(this.a.c,this.b,this.c),0,null)},
gaH(){var s=this,r=s.a,q=s.c,p=r.cK(q)
if(r.eN(q)===0&&p!==0){if(q-s.b===0)return p===r.b.length-1?"":A.bJ(B.M.bS(r.c,r.dG(p),r.dG(p+1)),0,null)}else q=p===r.b.length-1?r.c.length:r.dG(p+1)
return A.bJ(B.M.bS(r.c,r.dG(r.cK(s.b)),q),0,null)},
a_(a,b){var s
if(!(b instanceof A.er))return this.kP(0,b)
s=B.b.a_(this.b,b.b)
return s===0?B.b.a_(this.c,b.c):s},
D(a,b){var s=this
if(b==null)return!1
if(!(b instanceof A.er))return s.kO(0,b)
return s.b===b.b&&s.c===b.c&&J.A(s.a.a,b.a.a)},
gv(a){return A.c0(this.b,this.c,this.a.a,B.e,B.e,B.e)},
$ic2:1}
A.nb.prototype={
og(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.a
a.iV(B.c.gai(a1).c)
s=a.e
r=A.b7(s,a0,!1,t.dd)
for(q=a.r,s=s!==0,p=a.b,o=0;o<a1.length;++o){n=a1[o]
if(o>0){m=a1[o-1]
l=n.c
if(!J.A(m.c,l)){a.e2("\u2575")
q.a+="\n"
a.iV(l)}else if(m.b+1!==n.b){a.mU("...")
q.a+="\n"}}for(l=n.d,k=A.a5(l).h("d8<1>"),j=new A.d8(l,k),j=new A.at(j,j.gk(0),k.h("at<X.E>")),k=k.h("X.E"),i=n.b,h=n.a;j.m();){g=j.d
if(g==null)g=k.a(g)
f=g.a
if(f.gG().gW()!==f.gC().gW()&&f.gG().gW()===i&&a.lT(B.a.t(h,0,f.gG().ga7()))){e=B.c.cw(r,a0)
if(e<0)A.r(A.J(A.q(r)+" contains no null elements.",a0))
r[e]=g}}a.mT(i)
q.a+=" "
a.mS(n,r)
if(s)q.a+=" "
d=B.c.oj(l,new A.nw())
c=d===-1?a0:l[d]
k=c!=null
if(k){j=c.a
g=j.gG().gW()===i?j.gG().ga7():0
a.mQ(h,g,j.gC().gW()===i?j.gC().ga7():h.length,p)}else a.e4(h)
q.a+="\n"
if(k)a.mR(n,c,r)
for(l=l.length,b=0;b<l;++b)continue}a.e2("\u2575")
a1=q.a
return a1.charCodeAt(0)==0?a1:a1},
iV(a){var s,r,q=this
if(!q.f||!t.R.b(a))q.e2("\u2577")
else{q.e2("\u250c")
q.aM(new A.nj(q),"\x1b[34m")
s=q.r
r=" "+$.ww().jI(a)
s.a+=r}q.r.a+="\n"},
e0(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h=this,g={}
g.a=!1
g.b=null
s=c==null
if(s)r=null
else r=h.b
for(q=b.length,p=h.b,s=!s,o=h.r,n=!1,m=0;m<q;++m){l=b[m]
k=l==null
j=k?null:l.a.gG().gW()
i=k?null:l.a.gC().gW()
if(s&&l===c){h.aM(new A.nq(h,j,a),r)
n=!0}else if(n)h.aM(new A.nr(h,l),r)
else if(k)if(g.a)h.aM(new A.ns(h),g.b)
else o.a+=" "
else h.aM(new A.nt(g,h,c,j,a,l,i),p)}},
mS(a,b){return this.e0(a,b,null)},
mQ(a,b,c,d){var s=this
s.e4(B.a.t(a,0,b))
s.aM(new A.nk(s,a,b,c),d)
s.e4(B.a.t(a,c,a.length))},
mR(a,b,c){var s,r=this,q=r.b,p=b.a
if(p.gG().gW()===p.gC().gW()){r.fE()
p=r.r
p.a+=" "
r.e0(a,c,b)
if(c.length!==0)p.a+=" "
r.iW(b,c,r.aM(new A.nl(r,a,b),q))}else{s=a.b
if(p.gG().gW()===s){if(B.c.U(c,b))return
A.ES(c,b)
r.fE()
p=r.r
p.a+=" "
r.e0(a,c,b)
r.aM(new A.nm(r,a,b),q)
p.a+="\n"}else if(p.gC().gW()===s){p=p.gC().ga7()
if(p===a.a.length){A.z9(c,b)
return}r.fE()
r.r.a+=" "
r.e0(a,c,b)
r.iW(b,c,r.aM(new A.nn(r,!1,a,b),q))
A.z9(c,b)}}},
iU(a,b,c){var s=c?0:1,r=this.r
s=B.a.aL("\u2500",1+b+this.f5(B.a.t(a.a,0,b+s))*3)
r.a=(r.a+=s)+"^"},
mP(a,b){return this.iU(a,b,!0)},
iW(a,b,c){this.r.a+="\n"
return},
e4(a){var s,r,q,p
for(s=new A.br(a),r=t.V,s=new A.at(s,s.gk(0),r.h("at<y.E>")),q=this.r,r=r.h("y.E");s.m();){p=s.d
if(p==null)p=r.a(p)
if(p===9)q.a+=B.a.aL(" ",4)
else{p=A.aR(p)
q.a+=p}}},
e3(a,b,c){var s={}
s.a=c
if(b!=null)s.a=B.b.j(b+1)
this.aM(new A.nu(s,this,a),"\x1b[34m")},
e2(a){return this.e3(a,null,null)},
mU(a){return this.e3(null,null,a)},
mT(a){return this.e3(null,a,null)},
fE(){return this.e3(null,null,null)},
f5(a){var s,r,q,p
for(s=new A.br(a),r=t.V,s=new A.at(s,s.gk(0),r.h("at<y.E>")),r=r.h("y.E"),q=0;s.m();){p=s.d
if((p==null?r.a(p):p)===9)++q}return q},
lT(a){var s,r,q
for(s=new A.br(a),r=t.V,s=new A.at(s,s.gk(0),r.h("at<y.E>")),r=r.h("y.E");s.m();){q=s.d
if(q==null)q=r.a(q)
if(q!==32&&q!==9)return!1}return!0},
ln(a,b){var s,r=this.b!=null
if(r&&b!=null)this.r.a+=b
s=a.$0()
if(r&&b!=null)this.r.a+="\x1b[0m"
return s},
aM(a,b){return this.ln(a,b,t.z)}}
A.nv.prototype={
$0(){return this.a},
$S:88}
A.nd.prototype={
$1(a){var s=a.d
return new A.c7(s,new A.nc(),A.a5(s).h("c7<1>")).gk(0)},
$S:89}
A.nc.prototype={
$1(a){var s=a.a
return s.gG().gW()!==s.gC().gW()},
$S:23}
A.ne.prototype={
$1(a){return a.c},
$S:91}
A.ng.prototype={
$1(a){var s=a.a.gM()
return s==null?new A.k():s},
$S:184}
A.nh.prototype={
$2(a,b){return a.a.a_(0,b.a)},
$S:93}
A.ni.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=a.a,c=a.b,b=A.u([],t.dg)
for(s=J.bn(c),r=s.gA(c),q=t.g7;r.m();){p=r.gp().a
o=p.gaH()
n=A.uG(o,p.gah(),p.gG().ga7())
n.toString
m=B.a.e7("\n",B.a.t(o,0,n)).gk(0)
l=p.gG().gW()-m
for(p=o.split("\n"),n=p.length,k=0;k<n;++k){j=p[k]
if(b.length===0||l>B.c.gaQ(b).b)b.push(new A.by(j,l,d,A.u([],q)));++l}}i=A.u([],q)
for(r=b.length,h=i.$flags|0,g=0,k=0;k<b.length;b.length===r||(0,A.a6)(b),++k){j=b[k]
h&1&&A.C(i,16)
B.c.mm(i,new A.nf(j),!0)
f=i.length
for(q=s.aU(c,g),p=q.$ti,q=new A.at(q,q.gk(0),p.h("at<X.E>")),n=j.b,p=p.h("X.E");q.m();){e=q.d
if(e==null)e=p.a(e)
if(e.a.gG().gW()>n)break
i.push(e)}g+=i.length-f
B.c.aa(j.d,i)}return b},
$S:94}
A.nf.prototype={
$1(a){return a.a.gC().gW()<this.a.b},
$S:23}
A.nw.prototype={
$1(a){return!0},
$S:23}
A.nj.prototype={
$0(){this.a.r.a+=B.a.aL("\u2500",2)+">"
return null},
$S:0}
A.nq.prototype={
$0(){var s=this.a.r,r=this.b===this.c.b?"\u250c":"\u2514"
s.a+=r},
$S:1}
A.nr.prototype={
$0(){var s=this.a.r,r=this.b==null?"\u2500":"\u253c"
s.a+=r},
$S:1}
A.ns.prototype={
$0(){this.a.r.a+="\u2500"
return null},
$S:0}
A.nt.prototype={
$0(){var s,r,q=this,p=q.a,o=p.a?"\u253c":"\u2502"
if(q.c!=null)q.b.r.a+=o
else{s=q.e
r=s.b
if(q.d===r){s=q.b
s.aM(new A.no(p,s),p.b)
p.a=!0
if(p.b==null)p.b=s.b}else{s=q.r===r&&q.f.a.gC().ga7()===s.a.length
r=q.b
if(s)r.r.a+="\u2514"
else r.aM(new A.np(r,o),p.b)}}},
$S:1}
A.no.prototype={
$0(){var s=this.b.r,r=this.a.a?"\u252c":"\u250c"
s.a+=r},
$S:1}
A.np.prototype={
$0(){this.a.r.a+=this.b},
$S:1}
A.nk.prototype={
$0(){var s=this
return s.a.e4(B.a.t(s.b,s.c,s.d))},
$S:0}
A.nl.prototype={
$0(){var s,r,q=this.a,p=q.r,o=p.a,n=this.c.a,m=n.gG().ga7(),l=n.gC().ga7()
n=this.b.a
s=q.f5(B.a.t(n,0,m))
r=q.f5(B.a.t(n,m,l))
m+=s*3
n=(p.a+=B.a.aL(" ",m))+B.a.aL("^",Math.max(l+(s+r)*3-m,1))
p.a=n
return n.length-o.length},
$S:4}
A.nm.prototype={
$0(){return this.a.mP(this.b,this.c.a.gG().ga7())},
$S:0}
A.nn.prototype={
$0(){var s=this,r=s.a,q=r.r,p=q.a
if(s.b)q.a=p+B.a.aL("\u2500",3)
else r.iU(s.c,Math.max(s.d.a.gC().ga7()-1,0),!1)
return q.a.length-p.length},
$S:4}
A.nu.prototype={
$0(){var s=this.b,r=s.r,q=this.a.a
if(q==null)q=""
s=B.a.oL(q,s.d)
s=r.a+=s
q=this.c
r.a=s+(q==null?"\u2502":q)},
$S:1}
A.aP.prototype={
j(a){var s=this.a
s="primary "+(""+s.gG().gW()+":"+s.gG().ga7()+"-"+s.gC().gW()+":"+s.gC().ga7())
return s.charCodeAt(0)==0?s:s}}
A.rQ.prototype={
$0(){var s,r,q,p,o=this.a
if(!(t.ol.b(o)&&A.uG(o.gaH(),o.gah(),o.gG().ga7())!=null)){s=A.jb(o.gG().ga8(),0,0,o.gM())
r=o.gC().ga8()
q=o.gM()
p=A.Ek(o.gah(),10)
o=A.oC(s,A.jb(r,A.xU(o.gah()),p,q),o.gah(),o.gah())}return A.C6(A.C8(A.C7(o)))},
$S:96}
A.by.prototype={
j(a){return""+this.b+': "'+this.a+'" ('+B.c.bp(this.d,", ")+")"}}
A.bv.prototype={
fQ(a){var s=this.a
if(!J.A(s,a.gM()))throw A.a(A.J('Source URLs "'+A.q(s)+'" and "'+A.q(a.gM())+"\" don't match.",null))
return Math.abs(this.b-a.ga8())},
a_(a,b){var s=this.a
if(!J.A(s,b.gM()))throw A.a(A.J('Source URLs "'+A.q(s)+'" and "'+A.q(b.gM())+"\" don't match.",null))
return this.b-b.ga8()},
D(a,b){if(b==null)return!1
return t.hq.b(b)&&J.A(this.a,b.gM())&&this.b===b.ga8()},
gv(a){var s=this.a
s=s==null?null:s.gv(s)
if(s==null)s=0
return s+this.b},
j(a){var s=this,r=A.uL(s).j(0),q=s.a
return"<"+r+": "+s.b+" "+(A.q(q==null?"unknown source":q)+":"+(s.c+1)+":"+(s.d+1))+">"},
$ia7:1,
gM(){return this.a},
ga8(){return this.b},
gW(){return this.c},
ga7(){return this.d}}
A.jc.prototype={
fQ(a){if(!J.A(this.a.a,a.gM()))throw A.a(A.J('Source URLs "'+A.q(this.gM())+'" and "'+A.q(a.gM())+"\" don't match.",null))
return Math.abs(this.b-a.ga8())},
a_(a,b){if(!J.A(this.a.a,b.gM()))throw A.a(A.J('Source URLs "'+A.q(this.gM())+'" and "'+A.q(b.gM())+"\" don't match.",null))
return this.b-b.ga8()},
D(a,b){if(b==null)return!1
return t.hq.b(b)&&J.A(this.a.a,b.gM())&&this.b===b.ga8()},
gv(a){var s=this.a.a
s=s==null?null:s.gv(s)
if(s==null)s=0
return s+this.b},
j(a){var s=A.uL(this).j(0),r=this.b,q=this.a,p=q.a
return"<"+s+": "+r+" "+(A.q(p==null?"unknown source":p)+":"+(q.cK(r)+1)+":"+(q.eN(r)+1))+">"},
$ia7:1,
$ibv:1}
A.je.prototype={
l0(a,b,c){var s,r=this.b,q=this.a
if(!J.A(r.gM(),q.gM()))throw A.a(A.J('Source URLs "'+A.q(q.gM())+'" and  "'+A.q(r.gM())+"\" don't match.",null))
else if(r.ga8()<q.ga8())throw A.a(A.J("End "+r.j(0)+" must come after start "+q.j(0)+".",null))
else{s=this.c
if(s.length!==q.fQ(r))throw A.a(A.J('Text "'+s+'" must be '+q.fQ(r)+" characters long.",null))}},
gG(){return this.a},
gC(){return this.b},
gah(){return this.c}}
A.jf.prototype={
gjC(){return this.a},
j(a){var s,r,q,p=this.b,o="line "+(p.gG().gW()+1)+", column "+(p.gG().ga7()+1)
if(p.gM()!=null){s=p.gM()
r=$.ww()
s.toString
s=o+(" of "+r.jI(s))
o=s}o+=": "+this.a
q=p.oh(null)
p=q.length!==0?o+"\n"+q:o
return"Error on "+(p.charCodeAt(0)==0?p:p)},
$iO:1}
A.e5.prototype={
ga8(){var s=this.b
s=A.vo(s.a,s.b)
return s.b},
$iaU:1,
gdK(){return this.c}}
A.e6.prototype={
gM(){return this.gG().gM()},
gk(a){return this.gC().ga8()-this.gG().ga8()},
a_(a,b){var s=this.gG().a_(0,b.gG())
return s===0?this.gC().a_(0,b.gC()):s},
oh(a){var s=this
if(!t.ol.b(s)&&s.gk(s)===0)return""
return A.AB(s,a).og()},
D(a,b){if(b==null)return!1
return b instanceof A.e6&&this.gG().D(0,b.gG())&&this.gC().D(0,b.gC())},
gv(a){return A.c0(this.gG(),this.gC(),B.e,B.e,B.e,B.e)},
j(a){var s=this
return"<"+A.uL(s).j(0)+": from "+s.gG().j(0)+" to "+s.gC().j(0)+' "'+s.gah()+'">'},
$ia7:1}
A.c2.prototype={
gaH(){return this.d}}
A.e7.prototype={
aF(){return"SqliteUpdateKind."+this.b}}
A.ba.prototype={
gv(a){return A.c0(this.a,this.b,this.c,B.e,B.e,B.e)},
D(a,b){if(b==null)return!1
return b instanceof A.ba&&b.a===this.a&&b.b===this.b&&b.c===this.c},
j(a){return"SqliteUpdate: "+this.a.j(0)+" on "+this.b+", rowid = "+this.c}}
A.da.prototype={
j(a){var s,r,q=this,p=q.e
p=p==null?"":"while "+p+", "
p="SqliteException("+q.c+"): "+p+q.a
s=q.b
if(s!=null)p=p+", "+s
s=q.f
if(s!=null){r=q.d
r=r!=null?" (at position "+A.q(r)+"): ":": "
s=p+"\n  Causing statement"+r+s
p=q.r
p=p!=null?s+(", parameters: "+J.dE(p,new A.oH(),t.N).bp(0,", ")):s}return p.charCodeAt(0)==0?p:p},
$iO:1}
A.oH.prototype={
$1(a){if(t.p.b(a))return"blob ("+a.length+" bytes)"
else return J.be(a)},
$S:47}
A.my.prototype={
iT(){var s=this,r=s.d
return r==null?s.d=new A.cC(s,A.u([],t.fU),new A.mH(s),new A.mI(s),t.jy):r},
mv(){var s=this,r=s.e
return r==null?s.e=new A.cC(s,A.u([],t.lw),new A.mE(s),new A.mF(s),t.lU):r},
f3(){var s=this,r=s.f
return r==null?s.f=new A.cC(s,A.u([],t.lw),new A.mA(s),new A.mB(s),t.af):r},
n(){var s,r,q,p=this
if(p.r)return
p.r=!0
s=p.d
if(s!=null)s.n()
s=p.f
if(s!=null)s.n()
s=p.e
if(s!=null)s.n()
s=p.b
r=s.hv()
q=r!==0?A.wi(p.a,s,r,"closing database",null,null):null
if(q!=null)throw A.a(q)},
aY(a,b){var s,r,q
if(this.r)A.r(A.z("This database has already been closed"))
s=this.b
r=s.a
q=r.d7(B.o.av(a),1)
r=r.d
s=A.yT(r,"sqlite3_exec",[s.b,q,0,0,0])
r.dart_sqlite3_free(q)
if(s!==0)A.wp(this,s,"executing",a,b)},
gd8(){if(this.r)A.r(A.z("This database has already been closed"))
var s=this.b
return s.a.d.sqlite3_get_autocommit(s.b)!==0},
md(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(e.r)A.r(A.z("This database has already been closed"))
s=B.o.av(a)
r=e.b
q=r.a
p=q.fI(s)
o=q.ep(4)
n=q.ep(4)
m=new A.q3(r,p,o,n)
l=A.u([],t.lE)
k=new A.mC(m,l)
for(r=s.length,q=q.b,j=0;j<r;j=g){i=m.hw(j,r-j,0)
o=i.b
if(o!==0){k.$0()
A.wp(e,o,"preparing statement",a,null)}o=q.buffer
h=B.b.Y(o.byteLength,4)
g=new Int32Array(o,0,h)[B.b.a2(n,2)]-p
f=i.a
if(f!=null)l.push(new A.e8(f,e,new A.cF(!1).cU(s,j,g,!0)))
if(l.length===c){j=g
break}}if(b)while(j<r){i=m.hw(j,r-j,0)
o=q.buffer
h=B.b.Y(o.byteLength,4)
j=new Int32Array(o,0,h)[B.b.a2(n,2)]-p
f=i.a
if(f!=null){l.push(new A.e8(f,e,""))
k.$0()
throw A.a(A.b_(a,"sql","Had an unexpected trailing statement."))}else if(i.b!==0){k.$0()
throw A.a(A.b_(a,"sql","Has trailing data after the first sql statement:"))}}m.n()
return l},
jH(a,b){var s=this.md(a,b,1,!1,!0)
if(s.length===0)throw A.a(A.b_(a,"sql","Must contain an SQL statement."))
return B.c.gai(s)},
oO(a){return this.jH(a,!1)}}
A.mH.prototype={
$0(){var s=this.a,r=s.b
r.a.jd(r.b,new A.mG(s))},
$S:0}
A.mG.prototype={
$3(a,b,c){var s=A.Bp(a)
if(s==null)return
this.a.d.fP(new A.ba(s,b,c))},
$S:98}
A.mI.prototype={
$0(){var s=this.a.b
s.a.jd(s.b,null)
return null},
$S:0}
A.mE.prototype={
$0(){var s=this.a,r=s.b
r.a.jc(r.b,new A.mD(s))
return null},
$S:0}
A.mD.prototype={
$0(){this.a.e.fP(null)},
$S:0}
A.mF.prototype={
$0(){var s=this.a.b
s.a.jc(s.b,null)
return null},
$S:0}
A.mA.prototype={
$0(){var s=this.a,r=s.b
r.a.jb(r.b,new A.mz(s))
return null},
$S:0}
A.mz.prototype={
$0(){var s=this.a.f
s.fP(null)
return 0},
$S:4}
A.mB.prototype={
$0(){var s=this.a.b
s.a.jb(s.b,null)
return null},
$S:0}
A.mC.prototype={
$0(){var s,r,q,p,o,n
this.a.n()
for(s=this.b,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
if(!p.r){p.r=!0
if(!p.f){o=p.a
o.c.d.sqlite3_reset(o.b)
p.f=!0}o=p.a
n=o.c
n.d.sqlite3_finalize(o.b)
n=n.w
if(n!=null){n=n.a
if(n!=null)n.unregister(o.d)}}}},
$S:0}
A.cC.prototype={
gbB(){var s=this.r
return s==null?this.r=this.i7(!1):s},
i7(a){return new A.bz(!0,new A.ts(this,a),this.$ti.h("bz<1>"))},
fP(a){var s,r,q,p,o,n,m
for(s=this.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
o=p.a
if(p.b){n=o.b
if(n>=4)A.r(o.ap())
if((n&1)!==0)o.ga6().N(a)}else{n=o.b
if(n>=4)A.r(o.ap())
if((n&1)!==0)o.a1(a)
else if((n&3)===0){o=o.bX()
n=new A.bx(a)
m=o.c
if(m==null)o.b=o.c=n
else{m.sbs(n)
o.c=n}}}}},
n(){var s,r,q,p=this
for(s=p.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q)s[q].a.n()
p.d=null
if(p.b){p.f.$0()
p.b=!1}}}
A.ts.prototype={
$1(a){var s,r,q=this.a
if(q.a.r){a.n()
return}s=this.b
r=new A.tt(q,a,s)
a.r=a.e=new A.tu(q,a,s)
a.f=r
r.$0()},
$S(){return this.a.$ti.h("~(bZ<1>)")}}
A.tt.prototype={
$0(){var s=this.a,r=s.c,q=r.length
r.push(new A.hq(this.b,this.c))
if(q===0){if(s.a.r)A.r(A.z("This database has already been closed"))
s.e.$0()
s.b=!0}},
$S:0}
A.tu.prototype={
$0(){var s=this.a,r=s.c
B.c.H(r,new A.hq(this.b,this.c))
r=r.length
if(r===0&&!s.a.r){s.f.$0()
s.b=!1}},
$S:0}
A.oD.prototype={
jw(){var s=null,r=this.a.a.d.sqlite3_initialize()
if(r!==0)throw A.a(A.jj(s,s,r,"Error returned by sqlite3_initialize",s,s,s))},
oH(a,b){var s,r,q,p,o,n,m,l,k,j,i
this.jw()
switch(2){case 2:break}s=this.a
r=s.a
q=r.d7(B.o.av(a),1)
p=r.ep(4)
o=r.d7(B.o.av(b),1)
n=r.d
m=n.sqlite3_open_v2(q,p,6,o)
l=A.c_(r.b.buffer,0,null)[B.b.a2(p,2)]
n.dart_sqlite3_free(q)
n.dart_sqlite3_free(p)
n.dart_sqlite3_free(o)
k=new A.k()
j=new A.pX(r,l,k)
r=r.r
if(r!=null)r.j1(j,l,k)
if(m!==0){i=A.wi(s,j,m,"opening the database",null,null)
j.hv()
throw A.a(i)}n.sqlite3_extended_result_codes(l,1)
return new A.my(s,j,!1)}}
A.e8.prototype={
bw(a,b){A.wp(this.b,a,b,this.d,this.e)},
dR(){if(this.r||this.b.r)throw A.a(A.z(u.f))},
i1(){var s,r=this,q=r.f=!1,p=r.a,o=p.b
p=p.c.d
do s=p.sqlite3_step(o)
while(s===100)
r.dw()
if(s!==0?s!==101:q)r.bw(s,"executing statement")},
li(a){var s
this.dR()
s=this.a
s=s.c.d.sqlite3_bind_parameter_count(s.b)
if(0!==s)A.r(A.b_(a,"parameters","Expected "+A.q(s)+" parameters, got 0"))
return},
hI(a){A:{if(a instanceof A.nA){this.li(a.a)
break A}if(a instanceof A.f7)a.a.$1(this)}},
dw(){if(!this.f){var s=this.a
s.c.d.sqlite3_reset(s.b)
this.f=!0}},
n(){var s,r,q=this
if(!q.r){q.r=!0
q.dw()
s=q.a
r=s.c
r.d.sqlite3_finalize(s.b)
r=r.w
if(r!=null)r.jf(s.d)}},
nP(a){var s=this
s.dR()
s.dw()
s.hI(a)
s.i1()}}
A.it.prototype={
eH(a,b){return this.d.E(a)?1:0},
ho(a,b){this.d.H(0,a)},
hp(a){return new v.G.URL(a,"file:///").pathname},
ce(a,b){var s,r=a.a
if(r==null)r=A.wW(this.b,"/")
s=this.d
if(!s.E(r))if((b&4)!==0)s.l(0,r,new A.bg(new Uint8Array(0),0))
else throw A.a(A.dh(14))
return new A.ez(new A.k_(this,r,(b&8)!==0),0)},
hr(a){}}
A.k_.prototype={
jJ(a,b){var s,r=this.a.d.i(0,this.b)
if(r==null||r.b<=b)return 0
s=Math.min(a.length,r.b-b)
B.f.af(a,0,s,J.cM(B.f.gar(r.a),b,s))
return s},
hn(){return this.d>=2?1:0},
eI(){if(this.c)this.a.d.H(0,this.b)},
cI(){return this.a.d.i(0,this.b).b},
hq(a){this.d=a},
hs(a){},
dE(a){var s=this.a.d,r=this.b,q=s.i(0,r)
if(q==null){s.l(0,r,new A.bg(new Uint8Array(0),0))
s.i(0,r).sk(0,a)}else q.sk(0,a)},
ht(a){this.d=a},
cJ(a,b){var s,r=this.a.d,q=this.b,p=r.i(0,q)
if(p==null){p=new A.bg(new Uint8Array(0),0)
r.l(0,q,p)}s=b+a.length
if(s>p.b)p.sk(0,s)
p.af(0,b,s,a)}}
A.v3.prototype={
$1(a){return a.length!==0},
$S:25}
A.m6.prototype={
lj(){var s,r,q,p,o=A.T(t.N,t.S)
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
o.l(0,p,B.c.cA(s,p))}this.c=o}}
A.bG.prototype={
gA(a){return new A.kk(this)},
i(a,b){return new A.aW(this,A.nP(this.d[b],t.X))},
l(a,b,c){throw A.a(A.P("Can't change rows from a result set"))},
gk(a){return this.d.length},
$ix:1,
$in:1,
$it:1}
A.aW.prototype={
i(a,b){var s
if(typeof b!="string"){if(A.hH(b))return this.b[b]
return null}s=this.a.c.i(0,b)
if(s==null)return null
return this.b[s]},
ga3(){return this.a.a},
$ia_:1}
A.kk.prototype={
gp(){var s=this.a
return new A.aW(s,A.nP(s.d[this.b],t.X))},
m(){return++this.b<this.a.d.length}}
A.kl.prototype={}
A.km.prototype={}
A.ko.prototype={}
A.kp.prototype={}
A.o1.prototype={
aF(){return"OpenMode."+this.b}}
A.cU.prototype={}
A.nA.prototype={}
A.f7.prototype={}
A.c6.prototype={
j(a){return"VfsException("+this.a+")"},
$iO:1}
A.fF.prototype={}
A.aC.prototype={}
A.i2.prototype={}
A.i1.prototype={
geJ(){return 0},
jX(a,b){return 12},
geL(){return 4096},
eK(a,b){var s=this.jJ(a,b),r=a.length
if(s<r){B.f.fT(a,s,r,0)
throw A.a(B.bZ)}},
$iaO:1,
$ifW:1}
A.dj.prototype={}
A.vb.prototype={
$0(){var s,r,q
for(s=this.a;!s.gF(0);){if(s.b===0)A.r(A.z("No such element"))
r=s.c
q=r.a
q.toString
q.fB(A.p(r).h("aH.E").a(r))
r.d.$0()}},
$S:0}
A.v9.prototype={
$1(a){var s=this.a,r=s.b
s.dS(s.c,new A.dj(a),!1)
if(r===0)v.G.Promise.resolve().then(this.b)},
$S:14}
A.va.prototype={
$4(a,b,c,d){this.a.$1(c.d9(d))},
$S:100}
A.q1.prototype={}
A.pX.prototype={
hv(){var s=this.a,r=s.r
if(r!=null)r.jf(this.c)
return s.d.sqlite3_close_v2(this.b)}}
A.q3.prototype={
n(){var s=this,r=s.a.a.d
r.dart_sqlite3_free(s.b)
r.dart_sqlite3_free(s.c)
r.dart_sqlite3_free(s.d)},
hw(a,b,c){var s,r,q=this,p=q.a,o=p.a,n=q.c
p=A.yT(o.d,"sqlite3_prepare_v3",[p.b,q.b+a,b,c,n,q.d])
s=A.c_(o.b.buffer,0,null)[B.b.a2(n,2)]
if(s===0)r=null
else{n=new A.k()
r=new A.q2(s,o,n)
o=o.w
if(o!=null)o.j1(r,s,n)}return new A.ke(r,p)}}
A.q2.prototype={
kG(a,b,c,d){var s,r
if(d===0)return
s=this.c
r=s.d.sqlite3_column_blob(this.b,a)
B.f.af(b,c,c+d,A.aV(s.b.buffer,r,d))}}
A.di.prototype={}
A.cx.prototype={}
A.ed.prototype={
sk(a,b){throw A.a(A.P("Setting length in WasmValueList"))},
i(a,b){A.c_(this.a.b.buffer,0,null)
B.b.a2(this.c+b*4,2)
return new A.cx()},
l(a,b,c){throw A.a(A.P("Setting element in WasmValueList"))},
gk(a){return this.b}}
A.id.prototype={
oB(a){var s=this.b
s===$&&A.L()
A.v6("[sqlite3] "+A.eg(s,a,null))},
ow(a,b){var s,r,q,p=A.R(v.G.Number(a))*1000
if(p<-864e13||p>864e13)A.r(A.ac(p,-864e13,864e13,"millisecondsSinceEpoch",null))
A.bd(!1,"isUtc",t.y)
s=new A.bT(p,0,!1)
r=this.b
r===$&&A.L()
q=A.B_(r.buffer,b,8)
q.$flags&2&&A.C(q)
q[0]=A.xi(s)
q[1]=A.xg(s)
q[2]=A.xf(s)
q[3]=A.xe(s)
q[4]=A.xh(s)-1
q[5]=A.xj(s)-1900
q[6]=B.b.aT(A.B6(s),7)},
pF(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=null
try{p=this.b
p===$&&A.L()
s=new A.fF(A.vL(p,b,j))
r=a.ce(s,d)
if(e!==0){o=r.b
n=A.c_(p.buffer,0,j)
m=B.b.a2(e,2)
n.$flags&2&&A.C(n)
n[m]=o}p=A.c_(p.buffer,0,j)
o=B.b.a2(c,2)
p.$flags&2&&A.C(p)
p[o]=0
l=r.a
return l}catch(k){p=A.E(k)
if(p instanceof A.c6){q=p
p=this.b
p===$&&A.L()
o=q.a
p=A.c_(p.buffer,0,j)
n=B.b.a2(c,2)
p.$flags&2&&A.C(p)
p[n]=o}else{p=this.b
p===$&&A.L()
p=p.buffer
p=A.c_(p,0,j)
o=B.b.a2(c,2)
p.$flags&2&&A.C(p)
p[o]=1}}return j},
ps(a,b,c){return A.aT(new A.mh(this,b,a,c))},
pk(a,b,c,d){return A.aT(new A.md(this,b,a,c,d))},
pB(a,b,c,d){return A.aT(new A.mm(this,b,a,c,d))},
pH(a,b,c){return A.aT(new A.mo(this,c,b,a))},
pM(a,b){return A.aT(new A.mr(a,b))},
pq(a,b){return A.aT(new A.mg(this,a,b))},
po(a){return A.aT(new A.mf(a))},
pJ(a,b,c,d){return A.aT(new A.mp(this,a,b,c,d))},
pU(a,b,c,d){return A.aT(new A.mv(this,a,b,c,d))},
pQ(a,b){return A.aT(new A.mt(a,b))},
pO(a,b){return A.aT(new A.ms(a,b))},
px(a,b){return A.aT(new A.ml(this,a,b))},
pz(a,b){return A.aT(new A.mk(this,a,b))},
pD(a,b){return A.aT(new A.mn(a,b))},
pS(a,b){return A.aT(new A.mu(a,b))},
pm(a,b){return A.aT(new A.me(this,a,b))},
pt(a){return A.cf(new A.mi(a),0)},
pv(a,b,c){return A.cf(new A.mj(a,b,c),10)},
pK(a){return A.cf(new A.mq(a),4096)},
nu(a){A.cf(a,null)},
np(a){return A.cf(a,1)},
ns(a,b,c,d,e){A.cf(new A.mb(this,d,a,b,e),null)},
nA(a,b,c,d){var s=a.gq9(),r=this.a
r===$&&A.L()
s.$2(new A.di(),new A.ed(r,c,d))},
nE(a,b,c,d){var s=a.gqb(),r=this.a
r===$&&A.L()
s.$2(new A.di(),new A.ed(r,c,d))},
nC(a,b,c,d){var s=a.gqa(),r=this.a
r===$&&A.L()
s.$2(new A.di(),new A.ed(r,c,d))},
nG(a,b){var s=a.gqc()
this.a===$&&A.L()
s.$1(new A.di())},
ny(a,b){var s=a.gq8()
this.a===$&&A.L()
s.$1(new A.di())},
nw(a,b,c,d,e){return A.cf(new A.mc(this,c,b,e,d,a),0)},
nn(a,b){return A.cf(new A.ma(a,b),0)},
nl(a,b){return A.cf(new A.m9(a,b),1)},
nj(a,b,c){return A.cf(new A.m8(a,b,c),2)}}
A.mh.prototype={
$0(){var s=this,r=s.a.b
r===$&&A.L()
s.c.ho(A.eg(r,s.b,null),s.d)},
$S:0}
A.md.prototype={
$0(){var s,r,q=this,p=q.a.b
p===$&&A.L()
s=q.c.eH(A.eg(p,q.b,null),q.d)
p=A.c_(p.buffer,0,null)
r=B.b.a2(q.e,2)
p.$flags&2&&A.C(p)
p[r]=s},
$S:0}
A.mm.prototype={
$0(){var s,r,q,p=this,o=p.a.b
o===$&&A.L()
s=B.o.av(p.c.hp(A.eg(o,p.b,null)))
r=s.length
if(r>=p.d)throw A.a(A.dh(14))
o=A.aV(o.buffer,0,null)
q=p.e
B.f.cM(o,q,s)
o.$flags&2&&A.C(o)
o[q+r]=0},
$S:0}
A.mo.prototype={
$0(){var s,r=this,q=r.a.b
q===$&&A.L()
s=A.aV(q.buffer,r.b,r.c)
q=r.d
if(q!=null)A.wD(s,q.b)
else return A.wD(s,null)},
$S:0}
A.mr.prototype={
$0(){this.a.hr(A.mS(this.b,0))},
$S:0}
A.mg.prototype={
$0(){var s,r=Date.now(),q=this.a.b
q===$&&A.L()
s=v.G.BigInt(r)
A.x9(A.x8(q.buffer,0,null),this.c,s,!0)},
$S:0}
A.mf.prototype={
$0(){return this.a.eI()},
$S:0}
A.mp.prototype={
$0(){var s=this,r=s.a.b
r===$&&A.L()
s.b.eK(A.aV(r.buffer,s.c,s.d),A.R(v.G.Number(s.e)))},
$S:0}
A.mv.prototype={
$0(){var s=this,r=s.a.b
r===$&&A.L()
s.b.cJ(A.aV(r.buffer,s.c,s.d),A.R(v.G.Number(s.e)))},
$S:0}
A.mt.prototype={
$0(){return this.a.dE(A.R(v.G.Number(this.b)))},
$S:0}
A.ms.prototype={
$0(){return this.a.hs(this.b)},
$S:0}
A.ml.prototype={
$0(){var s,r,q=this.b.cI()
if(q>2147483647)throw A.a(A.dh(1802))
s=this.a.b
s===$&&A.L()
s=A.c_(s.buffer,0,null)
r=B.b.a2(this.c,2)
s.$flags&2&&A.C(s)
s[r]=q},
$S:0}
A.mk.prototype={
$0(){var s,r=this.b.cI(),q=this.a.b
q===$&&A.L()
s=v.G.BigInt(r)
A.x9(A.x8(q.buffer,0,null),this.c,s,!0)},
$S:0}
A.mn.prototype={
$0(){return this.a.hq(this.b)},
$S:0}
A.mu.prototype={
$0(){return this.a.ht(this.b)},
$S:0}
A.me.prototype={
$0(){var s,r=this.b.hn(),q=this.a.b
q===$&&A.L()
q=A.c_(q.buffer,0,null)
s=B.b.a2(this.c,2)
q.$flags&2&&A.C(q)
q[s]=r},
$S:0}
A.mi.prototype={
$0(){return this.a.geJ()},
$S:4}
A.mj.prototype={
$0(){var s=this.a
if(t.j2.b(s))return s.jX(this.b,this.c)
return 12},
$S:4}
A.mq.prototype={
$0(){var s=this.a
if(t.j2.b(s))return s.geL()
return 4096},
$S:4}
A.mb.prototype={
$0(){var s=this,r=s.a.b
r===$&&A.L()
s.c.$3(s.d,A.eg(r,s.b,null),A.R(v.G.Number(s.e)))},
$S:1}
A.mc.prototype={
$0(){var s,r,q=this,p=q.a.b
p===$&&A.L()
s=A.vL(p,q.b,q.c)
r=A.vL(p,q.d,q.e)
return q.f.gq_().$2(s,r)},
$S:4}
A.ma.prototype={
$0(){return this.a.$1(this.b)},
$S:4}
A.m9.prototype={
$0(){return this.a.gq1().$1(this.b)},
$S:4}
A.m8.prototype={
$0(){return this.a.gq0().$2(this.b,this.c)},
$S:4}
A.eW.prototype={
B(a,b,c,d){var s,r=null,q={},p=A.S(A.vt(this.a,v.G.Symbol.asyncIterator,r,r,r,r)),o=A.bI(r,r,r,r,!0,this.$ti.c)
q.a=null
s=new A.l5(q,this,p,o)
o.d=s
o.f=new A.l6(q,o,s)
return new A.a4(o,A.p(o).h("a4<1>")).B(a,b,c,d)},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.l5.prototype={
$0(){var s,r=this,q=r.c.next(),p=r.a
p.a=q
s=r.d
A.ar(q,t.m).bb(new A.l7(p,r.b,s,r),s.gfG(),t.P)},
$S:0}
A.l7.prototype={
$1(a){var s,r,q=this,p=a.done
if(p==null)p=null
s=a.value
r=q.c
if(p===!0){r.n()
q.a.a=null}else{r.q(0,s==null?q.b.$ti.c.a(s):s)
q.a.a=null
p=r.b
if(!((p&1)!==0?(r.ga6().e&4)!==0:(p&2)===0))q.d.$0()}},
$S:15}
A.l6.prototype={
$0(){var s,r
if(this.a.a==null){s=this.b
r=s.b
s=!((r&1)!==0?(s.ga6().e&4)!==0:(r&2)===0)}else s=!1
if(s)this.c.$0()},
$S:0}
A.dn.prototype={
u(){var s=0,r=A.i(t.H),q=this,p
var $async$u=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=q.b
if(p!=null)p.u()
p=q.c
if(p!=null)p.u()
q.c=q.b=null
return A.f(null,r)}})
return A.h($async$u,r)},
gp(){var s=this.a
return s==null?A.r(A.z("Await moveNext() first")):s},
m(){var s,r,q,p=this,o=p.a
if(o!=null)o.continue()
o=new A.l($.m,t.B)
s=new A.N(o,t.ex)
r=p.d
q=t.m
p.b=A.aD(r,"success",new A.rh(p,s),!1,q)
p.c=A.aD(r,"error",new A.ri(p,s),!1,q)
return o}}
A.rh.prototype={
$1(a){var s,r=this.a
r.u()
s=r.$ti.h("1?").a(r.d.result)
r.a=s
this.b.T(s!=null)},
$S:2}
A.ri.prototype={
$1(a){var s=this.a
s.u()
s=s.d.error
if(s==null)s=a
this.b.ab(s)},
$S:2}
A.lP.prototype={
$1(a){this.a.T(this.c.a(this.b.result))},
$S:2}
A.lQ.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.ab(s)},
$S:2}
A.lU.prototype={
$1(a){this.a.T(this.c.a(this.b.result))},
$S:2}
A.lV.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.ab(s)},
$S:2}
A.lW.prototype={
$1(a){this.a.ab(new A.aX("IndexedDB open blocked"))},
$S:2}
A.mX.prototype={
$1(a){return A.S(a[1])},
$S:121}
A.pY.prototype={
nc(){var s={}
s.dart=new A.pZ(this).$0()
return s},
eo(a){return this.os(a)},
os(a){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$eo=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(A.ar(v.G.WebAssembly.instantiateStreaming(a,p.nc()),t.m),$async$eo)
case 3:o=c
n=o.instance.exports
if("_initialize" in n)t.g.a(n._initialize).call()
q=o.instance
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$eo,r)}}
A.pZ.prototype={
$0(){var s=this.a.a,r=A.S(v.G.Object),q=A.S(r.create.apply(r,[null]))
q.error_log=A.bB(s.goA())
q.localtime=A.aZ(s.gov())
q.xOpen=A.wa(s.gpE())
q.xDelete=A.kM(s.gpr())
q.xAccess=A.eK(s.gpj())
q.xFullPathname=A.eK(s.gpA())
q.xRandomness=A.kM(s.gpG())
q.xSleep=A.aZ(s.gpL())
q.xCurrentTimeInt64=A.aZ(s.gpp())
q.xClose=A.bB(s.gpn())
q.xRead=A.eK(s.gpI())
q.xWrite=A.eK(s.gpT())
q.xTruncate=A.aZ(s.gpP())
q.xSync=A.aZ(s.gpN())
q.xFileSize=A.aZ(s.gpw())
q.xFileSize64=A.aZ(s.gpy())
q.xLock=A.aZ(s.gpC())
q.xUnlock=A.aZ(s.gpR())
q.xCheckReservedLock=A.aZ(s.gpl())
q.xDeviceCharacteristics=A.bB(s.geJ())
q.xFileControl=A.kM(s.gpu())
q.xSectorSize=A.bB(s.geL())
q["dispatch_()v"]=A.bB(s.gnt())
q["dispatch_()i"]=A.bB(s.gno())
q.dispatch_update=A.wa(s.gnr())
q.dispatch_xFunc=A.eK(s.gnz())
q.dispatch_xStep=A.eK(s.gnD())
q.dispatch_xInverse=A.eK(s.gnB())
q.dispatch_xValue=A.aZ(s.gnF())
q.dispatch_xFinal=A.aZ(s.gnx())
q.dispatch_compare=A.wa(s.gnv())
q.dispatch_busy=A.aZ(s.gnm())
q.changeset_apply_filter=A.aZ(s.gnk())
q.changeset_apply_conflict=A.kM(s.gni())
return q},
$S:19}
A.ec.prototype={}
A.lc.prototype={
es(){var s=0,r=A.i(t.H),q=this,p,o
var $async$es=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=new A.l($.m,t.a7)
o=v.G.indexedDB.open(q.b,1)
o.onupgradeneeded=A.bB(new A.lf(o))
new A.N(p,t.h1).T(A.Ai(o,t.m))
s=2
return A.b(p,$async$es)
case 2:q.a=b
return A.f(null,r)}})
return A.h($async$es,r)},
cp(a,b){return this.mw(a,b)},
mw(a,b){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$cp=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=q.a
n.toString
p=n.transaction($.zO(),b)
o=A.C9(p)
s=2
return A.b(A.EU(new A.le(a,o,p),t.mj),$async$cp)
case 2:s=3
return A.b(o.b.a,$async$cp)
case 3:if(o.c){n=q.a
if(n!=null)n.close()
q.a=null}return A.f(null,r)}})
return A.h($async$cp,r)},
mb(a){return this.cp(new A.ld(a),"readwrite")}}
A.lf.prototype={
$1(a){var s=A.S(this.a.result)
if(J.A(a.oldVersion,0)){s.createObjectStore("files",{autoIncrement:!0}).createIndex("fileName","name",{unique:!0})
s.createObjectStore("blocks")}},
$S:15}
A.le.prototype={
$0(){var s=0,r=A.i(t.P),q=1,p=[],o=this,n,m
var $async$$0=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:q=3
s=6
return A.b(o.a.$1(o.b),$async$$0)
case 6:q=1
s=5
break
case 3:q=2
m=p.pop()
o.c.abort()
throw m
s=5
break
case 2:s=1
break
case 5:o.c.commit()
return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$0,r)},
$S:51}
A.ld.prototype={
$1(a){return this.jY(a)},
jY(a){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=q.a,o=p.length,n=0
case 2:if(!(n<p.length)){s=4
break}s=5
return A.b(p[n].an(a),$async$$1)
case 5:case 3:p.length===o||(0,A.a6)(p),++n
s=2
break
case 4:return A.f(null,r)}})
return A.h($async$$1,r)},
$S:16}
A.hd.prototype={
l7(a){var s=A.uc(new A.rT(this)),r=this.a
r.oncomplete=s
r.onabort=s
r.onerror=A.uc(new A.rU(this))},
fs(a,b,c){var s=t.gk
return v.G.IDBKeyRange.bound(A.u([a,c],s),A.u([a,b],s))},
mf(a){return this.fs(a,9007199254740992,0)},
mg(a,b){return this.fs(a,9007199254740992,b)},
en(){var s=0,r=A.i(t.dV),q,p=this,o,n,m,l,k
var $async$en=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:l=A.T(t.N,t.S)
k=new A.dn(p.d.index("fileName").openKeyCursor(),t.Q)
case 3:s=5
return A.b(k.m(),$async$en)
case 5:if(!b){s=4
break}o=k.a
if(o==null)o=A.r(A.z("Await moveNext() first"))
n=o.key
n.toString
A.al(n)
m=o.primaryKey
m.toString
l.l(0,n,A.R(A.bA(m)))
s=3
break
case 4:q=l
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$en,r)},
eg(a){return this.nS(a)},
nS(a){var s=0,r=A.i(t.I),q,p=this,o
var $async$eg=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=A
s=3
return A.b(A.bD(p.d.index("fileName").getKey(a),t.i),$async$eg)
case 3:q=o.R(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$eg,r)},
ft(a){return A.bD(this.d.get(a),t.mU).aK(new A.rS(a),t.m)},
cQ(a,b){return this.kH(a,b)},
kH(a,b){var s=0,r=A.i(t.oR),q,p=this,o,n,m,l,k,j,i,h,g,f,e
var $async$cQ=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.ft(a),$async$cQ)
case 3:h=d
g=h.length
f=new A.bg(new Uint8Array(g),g)
e=new A.dn(p.e.openCursor(p.mf(a)),t.Q)
g=t.a,o=v.G,n=t.c,m=t.H
case 4:s=6
return A.b(e.m(),$async$cQ)
case 6:if(!d){s=5
break}l=e.a
if(l==null)l=A.r(A.z("Await moveNext() first"))
k=n.a(l.key)
j=A.R(A.bA(k[1]))
if(j>=h.length){s=5
break}i=new A.rV(f,j,Math.min(4096,h.length-j))
if(l.value instanceof o.Blob)b.push(A.og(A.S(l.value)).aK(i,m))
else i.$1(g.a(l.value))
s=4
break
case 5:q=f
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cQ,r)},
ec(a){return this.nb(a)},
nb(a){var s=0,r=A.i(t.S),q,p=this,o
var $async$ec=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:if((p.b.a.a&30)!==0)A.r(A.z("IDB transaction already completed"))
o=A
s=3
return A.b(A.bD(p.d.put({name:a,length:0}),t.i),$async$ec)
case 3:q=o.R(c)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ec,r)},
cd(a,b){return this.pe(a,b)},
pe(a,b){var s=0,r=A.i(t.H),q=this,p,o,n,m,l
var $async$cd=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:if((q.b.a.a&30)!==0)A.r(A.z("IDB transaction already completed"))
s=2
return A.b(q.ft(a),$async$cd)
case 2:p=d
o=b.b
n=A.p(o).h("b5<1>")
m=A.ap(new A.b5(o,n),n.h("n.E"))
B.c.kF(m)
s=3
return A.b(A.n7(new A.a8(m,new A.rW(new A.rX(q,a),b),A.a5(m).h("a8<1,o<~>>")),t.H),$async$cd)
case 3:s=b.c!==p.length?4:5
break
case 4:l=new A.dn(q.d.openCursor(a),t.Q)
s=6
return A.b(l.m(),$async$cd)
case 6:s=7
return A.b(A.bD(l.gp().update({name:p.name,length:b.c}),t.X),$async$cd)
case 7:case 5:return A.f(null,r)}})
return A.h($async$cd,r)},
cc(a,b,c){return this.p5(0,b,c)},
p5(a,b,c){var s=0,r=A.i(t.H),q=this,p,o
var $async$cc=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:if((q.b.a.a&30)!==0)A.r(A.z("IDB transaction already completed"))
s=2
return A.b(q.ft(b),$async$cc)
case 2:p=e
s=p.length>c?3:4
break
case 3:s=5
return A.b(A.bD(q.e.delete(q.mg(b,B.b.Y(c,4096)*4096)),t.X),$async$cc)
case 5:case 4:o=new A.dn(q.d.openCursor(b),t.Q)
s=6
return A.b(o.m(),$async$cc)
case 6:s=7
return A.b(A.bD(o.gp().update({name:p.name,length:c}),t.X),$async$cc)
case 7:return A.f(null,r)}})
return A.h($async$cc,r)},
ee(a){return this.nh(a)},
nh(a){var s=0,r=A.i(t.H),q=this,p
var $async$ee=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:if((q.b.a.a&30)!==0)A.r(A.z("IDB transaction already completed"))
p=t.X
s=2
return A.b(A.n7(A.u([A.bD(q.e.delete(q.fs(a,9007199254740992,0)),p),A.bD(q.d.delete(a),p)],t.M),t.H),$async$ee)
case 2:return A.f(null,r)}})
return A.h($async$ee,r)}}
A.rT.prototype={
$0(){this.a.b.L()},
$S:1}
A.rU.prototype={
$0(){var s=this.a,r=s.a.error
if(r==null)r=new v.G.DOMException("IDB transaction error")
s.b.ab(r)},
$S:1}
A.rS.prototype={
$1(a){if(a==null)throw A.a(A.b_(this.a,"fileId","File not found in database"))
else return a},
$S:123}
A.rV.prototype={
$1(a){var s=this.a
s.cM(s,this.b,J.cM(a,0,this.c))},
$S:124}
A.rX.prototype={
kn(a,b){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$$2=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p=q.a.e
o=q.b
n=t.gk
s=2
return A.b(A.bD(p.openCursor(v.G.IDBKeyRange.only(A.u([o,a],n))),t.mU),$async$$2)
case 2:m=d
l=t.a.a(B.f.gar(b))
k=t.X
s=m==null?3:5
break
case 3:s=6
return A.b(A.bD(p.put(l,A.u([o,a],n)),k),$async$$2)
case 6:s=4
break
case 5:s=7
return A.b(A.bD(m.update(l),k),$async$$2)
case 7:case 4:return A.f(null,r)}})
return A.h($async$$2,r)},
$2(a,b){return this.kn(a,b)},
$S:125}
A.rW.prototype={
$1(a){var s=this.b.b.i(0,a)
s.toString
return this.a.$2(a,s)},
$S:126}
A.rw.prototype={
mL(a,b,c){B.f.cM(this.b.cD(a,new A.rx(this,a)),b,c)},
n3(a,b){var s,r,q,p,o,n,m,l
for(s=b.length,r=0;r<s;r=l){q=a+r
p=B.b.Y(q,4096)
o=B.b.aT(q,4096)
n=s-r
if(o!==0)m=Math.min(4096-o,n)
else{m=Math.min(4096,n)
o=0}l=r+m
this.mL(p*4096,o,J.cM(B.f.gar(b),b.byteOffset+r,m))}this.c=Math.max(this.c,a+s)}}
A.rx.prototype={
$0(){var s=new Uint8Array(4096),r=this.a.a,q=r.length,p=this.b
if(q>p)B.f.cM(s,0,J.cM(B.f.gar(r),r.byteOffset+p,Math.min(4096,q-p)))
return s},
$S:127}
A.k7.prototype={}
A.cl.prototype={
d5(a){var s=this
if(s.e||s.d.a==null)A.r(A.dh(10))
if(a.h1(s.x)){s.c3(!0)
return a.d.a}else return A.n5(null,t.H)},
c3(a){return this.mE(a)},
mE(a){var s=0,r=A.i(t.H),q,p=this,o,n
var $async$c3=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:if(a&&!p.r){s=1
break}s=p.f==null&&!p.x.gF(0)?3:4
break
case 3:o=p.x
n=A.ap(o,o.$ti.h("n.E"))
o.au(0)
o=p.d.mb(n).J(new A.ny(p,n,a))
p.f=o
s=5
return A.b(o,$async$c3)
case 5:case 4:case 1:return A.f(q,r)}})
return A.h($async$c3,r)},
n(){var s=0,r=A.i(t.H),q,p=this,o,n
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if(!p.e){o=p.d5(new A.hb(new A.nz(),new A.N(new A.l($.m,t.D),t.F)))
p.e=!0
p.c3(!1)
q=o
s=1
break}else{n=p.x
if(!n.gF(0)){q=n.gaQ(0).d.a
s=1
break}}case 1:return A.f(q,r)}})
return A.h($async$n,r)},
cm(a,b){return this.lE(a,b)},
lE(a,b){var s=0,r=A.i(t.S),q,p=this,o,n
var $async$cm=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=p.z
s=n.E(b)?3:5
break
case 3:n=n.i(0,b)
n.toString
q=n
s=1
break
s=4
break
case 5:s=6
return A.b(a.eg(b),$async$cm)
case 6:o=d
o.toString
n.l(0,b,o)
q=o
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$cm,r)},
d_(){var s=0,r=A.i(t.H),q=this,p
var $async$d_=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=A.u([],t.M)
s=2
return A.b(q.d.cp(new A.nx(q,p),"readonly"),$async$d_)
case 2:s=3
return A.b(A.vp(p,t.H),$async$d_)
case 3:return A.f(null,r)}})
return A.h($async$d_,r)},
jn(){var s=this.f
return s==null?this.c3(!1):s},
eH(a,b){return this.w.d.E(a)?1:0},
ho(a,b){var s=this
s.w.d.H(0,a)
if(!s.y.H(0,a))s.d5(new A.h6(s,a,new A.N(new A.l($.m,t.D),t.F)))},
hp(a){return new v.G.URL(a,"file:///").pathname},
ce(a,b){var s,r,q,p=this,o=a.a
if(o==null)o=A.wW(p.b,"/")
s=p.w
r=s.d.E(o)?1:0
q=s.ce(new A.fF(o),b)
if(r===0)if((b&8)!==0)p.y.q(0,o)
else p.d5(new A.em(p,o,new A.N(new A.l($.m,t.D),t.F)))
return new A.ez(new A.k0(p,q.a,o),0)},
hr(a){}}
A.ny.prototype={
$0(){var s,r,q,p,o=this.a
o.f=null
for(s=this.b,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q].d.a
if((p.a&30)!==0)A.r(A.z("Future already completed"))
p.be(null)}o.c3(this.c)},
$S:1}
A.nz.prototype={
$1(a){return this.k7(a)},
k7(a){var s=0,r=A.i(t.H)
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:a.c=!0
return A.f(null,r)}})
return A.h($async$$1,r)},
$S:16}
A.nx.prototype={
$1(a){return this.k6(a)},
k6(a){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=2
return A.b(a.en(),$async$$1)
case 2:m=c
l=q.a
l.z.aa(0,m)
p=m.gbl(),p=p.gA(p),o=q.b,l=l.w.d
case 3:if(!p.m()){s=4
break}n=p.gp()
k=l
j=n.a
s=5
return A.b(a.cQ(n.b,o),$async$$1)
case 5:k.l(0,j,c)
s=3
break
case 4:return A.f(null,r)}})
return A.h($async$$1,r)},
$S:16}
A.k0.prototype={
eK(a,b){this.b.eK(a,b)},
geJ(){return 0},
geL(){return 4096},
hn(){return this.b.d>=2?1:0},
eI(){},
cI(){return this.b.cI()},
hq(a){this.b.d=a
return null},
hs(a){},
jX(a,b){return 12},
dE(a){var s=this,r=s.a
if(r.e||r.d.a==null)A.r(A.dh(10))
s.b.dE(a)
if(!r.y.U(0,s.c))r.d5(new A.hb(new A.rR(s,a),new A.N(new A.l($.m,t.D),t.F)))},
ht(a){this.b.d=a
return null},
cJ(a,b){var s,r,q,p,o,n,m=this,l=m.a
if(l.e||l.d.a==null)A.r(A.dh(10))
s=m.c
if(l.y.U(0,s)){m.b.cJ(a,b)
return}r=l.w.d.i(0,s)
if(r==null)r=new A.bg(new Uint8Array(0),0)
q=J.cM(B.f.gar(r.a),0,r.b)
m.b.cJ(a,b)
p=new Uint8Array(a.length)
B.f.cM(p,0,a)
o=A.u([],t.o6)
n=$.m
o.push(new A.k7(b,p))
l.d5(new A.eG(l,s,q,o,new A.N(new A.l(n,t.D),t.F)))},
$iaO:1,
$ifW:1}
A.rR.prototype={
$1(a){return this.km(a)},
km(a){var s=0,r=A.i(t.H),q,p=this,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=p.a
n=a
s=3
return A.b(o.a.cm(a,o.c),$async$$1)
case 3:q=n.cc(0,c,p.b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:16}
A.aE.prototype={
h1(a){a.dS(a.c,this,!1)
return!0}}
A.hb.prototype={
an(a){return this.w.$1(a)}}
A.h6.prototype={
h1(a){var s,r,q,p
if(!a.gF(0)){s=a.gaQ(0)
for(r=this.x;s!=null;)if(s instanceof A.h6)if(s.x===r)return!1
else s=s.gdu()
else if(s instanceof A.eG){q=s.gdu()
if(s.x===r){p=s.a
p.toString
p.fB(A.p(s).h("aH.E").a(s))}s=q}else if(s instanceof A.em){if(s.x===r){r=s.a
r.toString
r.fB(A.p(s).h("aH.E").a(s))
return!1}s=s.gdu()}else break}a.dS(a.c,this,!1)
return!0},
an(a){return this.oX(a)},
oX(a){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$an=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=q.w
o=q.x
s=2
return A.b(p.cm(a,o),$async$an)
case 2:n=c
p.z.H(0,o)
s=3
return A.b(a.ee(n),$async$an)
case 3:return A.f(null,r)}})
return A.h($async$an,r)}}
A.em.prototype={
an(a){return this.oW(a)},
oW(a){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$an=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:p=q.x
o=q.w.z
n=p
s=2
return A.b(a.ec(p),$async$an)
case 2:o.l(0,n,c)
return A.f(null,r)}})
return A.h($async$an,r)}}
A.eG.prototype={
h1(a){var s,r=a.b===0?null:a.gaQ(0)
for(s=this.x;r!=null;)if(r instanceof A.eG)if(r.x===s){B.c.aa(r.z,this.z)
return!1}else r=r.gdu()
else if(r instanceof A.em){if(r.x===s)break
r=r.gdu()}else break
a.dS(a.c,this,!1)
return!0},
an(a){return this.oY(a)},
oY(a){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$an=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:m=q.y
l=new A.rw(m,A.T(t.S,t.p),m.length)
for(m=q.z,p=m.length,o=0;o<m.length;m.length===p||(0,A.a6)(m),++o){n=m[o]
l.n3(n.a,n.b)}k=a
s=3
return A.b(q.w.cm(a,q.x),$async$an)
case 3:s=2
return A.b(k.cd(c,l),$async$an)
case 2:return A.f(null,r)}})
return A.h($async$an,r)}}
A.dO.prototype={
aF(){return"FileType."+this.b}}
A.e4.prototype={
b5(){var s=this.d
if(s!=null)return s
throw A.a(A.z("VFS closed"))},
eH(a,b){var s=$.vg().i(0,a)
if(s==null)return this.e.d.E(a)?1:0
else return this.b5().ji(s)?1:0},
ho(a,b){var s=$.vg().i(0,a)
if(s==null){this.e.d.H(0,a)
return null}else this.b5().dq(s,!1)},
hp(a){return new v.G.URL(a,"file:///").pathname},
ce(a,b){var s,r,q=this,p=a.a
if(p==null)return q.e.ce(a,b)
s=$.vg().i(0,p)
if(s==null)return q.e.ce(a,b)
r=q.b5()
if(!r.ji(s))if((b&4)!==0){r.c6(s).truncate(0)
r.dq(s,!0)}else throw A.a(B.bY)
return new A.ez(new A.kq(q,s,(b&8)!==0),0)},
hr(a){},
n(){var s=this.d
if(s!=null){s.b.close()
s.c.close()
s.d.close()}this.d=null},
bL(a,b){return this.oI(a,b)},
oG(a){return this.bL(a,!1)},
oI(a,b){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$bL=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:m=new A.oA(a,b)
s=2
return A.b(m.$1("meta"),$async$bL)
case 2:l=d
k=J.A(l.getSize(),0)
l.truncate(2)
s=3
return A.b(m.$1("database"),$async$bL)
case 3:p=d
s=4
return A.b(m.$1("journal"),$async$bL)
case 4:o=d
n=q.d=new A.ta(new Uint8Array(2),l,p,o)
if(k){n.dq(B.a9,p.getSize()>0)
n.dq(B.aa,o.getSize()>0)}return A.f(null,r)}})
return A.h($async$bL,r)}}
A.oA.prototype={
k9(a){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o=t.m
s=3
return A.b(A.ar(p.a.getFileHandle(a,{create:!0}),o),$async$$1)
case 3:n=c
s=4
return A.b(A.ar(p.b?n.createSyncAccessHandle({mode:"readwrite-unsafe"}):n.createSyncAccessHandle(),o),$async$$1)
case 4:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$1(a){return this.k9(a)},
$S:128}
A.kq.prototype={
jJ(a,b){return A.wT(this.a.b5().c6(this.b),a,{at:b})},
hn(){return this.d>=2?1:0},
eI(){var s=this.a,r=this.b
s.b5().c6(r).flush()
if(this.c)s.b5().dq(r,!1)},
cI(){return this.a.b5().c6(this.b).getSize()},
hq(a){this.d=a},
hs(a){this.a.b5().c6(this.b).flush()},
dE(a){this.a.b5().c6(this.b).truncate(a)},
ht(a){this.d=a},
cJ(a,b){if(A.wU(this.a.b5().c6(this.b),a,{at:b})<a.length)throw A.a(B.c_)}}
A.ta.prototype={
ji(a){var s=this.a
A.wT(this.b,s,{at:0})
return s[a.a]!==0},
dq(a,b){var s=this.a,r=b?1:0
s.$flags&2&&A.C(s)
s[a.a]=r
A.wU(this.b,s,{at:0})},
c6(a){var s
switch(a.a){case 0:s=this.c
break
case 1:s=this.d
break
default:s=null}return s}}
A.pS.prototype={
l3(a,b){var s=this,r=s.c
r.a!==$&&A.zd()
r.a=s
A.jX(new A.pT(s),t.h6)
r=t.S
A.jX(new A.pU(s),r)
s.r=A.jX(new A.pV(s),r)
s.w=A.jX(new A.pW(s),r)},
d7(a,b){var s=a.length,r=this.ep(s+b),q=A.aV(this.b.buffer,0,null)
s=r+s
B.f.af(q,r,s,a)
B.f.fT(q,s,s+b,0)
return r},
fI(a){return this.d7(a,0)},
ep(a){var s=this.d.dart_sqlite3_malloc(a)
if(s===0)throw A.a(A.z("out of wasm memory"))
return s},
jd(a,b){var s=b==null?null:b
return this.d.dart_sqlite3_updates(a,s)},
jb(a,b){var s=b==null?null:b
return this.d.dart_sqlite3_commits(a,s)},
jc(a,b){var s=b==null?null:b
return this.d.dart_sqlite3_rollbacks(a,s)}}
A.pT.prototype={
$1(a){a.q2(this.a)},
$S:129}
A.pU.prototype={
$1(a){return this.a.d.sqlite3session_delete(a)},
$S:8}
A.pV.prototype={
$1(a){return this.a.d.sqlite3_close_v2(a)},
$S:8}
A.pW.prototype={
$1(a){return this.a.d.sqlite3_finalize(a)},
$S:8}
A.dJ.prototype={}
A.o8.prototype={
hC(a){var s,r=this,q=r.a
q.start()
r.c=A.aD(q,"message",new A.oc(r),!1,t.m)
s=a.b
if(a.c==null&&s!=null){q=$.hO()
q.toString
A.ee(q,s,null,null,!1).aK(new A.od(r),t.P)}},
fk(a){return this.lI(a)},
lI(a){var s=0,r=A.i(t.H),q=this
var $async$fk=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:A.En(a,new A.o9(q),q.gjs(),new A.oa(q),new A.ob(q))
return A.f(null,r)}})
return A.h($async$fk,r)},
bR(a,b,c,d){return this.kE(a,b,c,d,d)},
cf(a,b,c){return this.bR(a,b,null,c)},
kE(a,b,c,d,e){var s=0,r=A.i(e),q,p=this,o,n,m,l
var $async$bR=A.d(function(f,g){if(f===1)return A.e(g,r)
for(;;)switch(s){case 0:l={}
if((p.b.a.a&30)!==0)throw A.a(A.A9(null))
o=p.e++
n=new A.l($.m,t.a7)
p.f.l(0,o,new A.N(n,t.h1))
a.i=o
p.a.postMessage(a,A.dA(a))
l.a=!1
if(c!=null)c.J(new A.oe(l,p,o))
s=3
return A.b(n,$async$bR)
case 3:m=g
l.a=!0
if(J.A(m.t,b.b)){q=d.a(m)
s=1
break}else throw A.a(A.Bf(m))
case 1:return A.f(q,r)}})
return A.h($async$bR,r)},
lX(a){var s,r,q=this,p=q.b
if((p.a.a&30)!==0)return
q.a.postMessage("_disconnect")
s=q.c
if(s!=null)s.u()
s=q.d
if(s!=null)s.u()
for(s=q.f,r=new A.b6(s,s.r,s.e);r.m();)r.d.ab(new A.f_(a))
s.au(0)
p.L()},
ij(){return this.lX(null)}}
A.oc.prototype={
$1(a){if(a.data=="_disconnect"){this.a.ij()
return}this.a.fk(A.S(a.data))},
$S:2}
A.od.prototype={
$1(a){this.a.ij()
a.a.L()},
$S:130}
A.ob.prototype={
$1(a){var s=this.a.f.H(0,a.i)
if(s!=null)s.T(a)},
$S:15}
A.oa.prototype={
$1(a){return this.k8(a)},
k8(a1){var s=0,r=A.i(t.P),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$$1=A.d(function(a2,a3){if(a2===1){p.push(a3)
s=q}for(;;)switch(s){case 0:f=null
e=a1.i
d=n.a
c=d.r
b=v.G
a=new b.AbortController()
c.l(0,e,a)
m=a
q=3
j=d.nq(a1,m.signal)
s=6
return A.b(t.nW.b(j)?j:A.bM(j,t.m),$async$$1)
case 6:f=a3
o.push(5)
s=4
break
case 3:q=2
a0=p.pop()
l=A.E(a0)
k=A.I(a0)
if(!(l instanceof A.bq)){b.console.error("Error in worker: "+J.be(l))
b.console.error("Original trace: "+A.q(k))}b=l
if(b instanceof A.da){h=A.Au(b)
g=0}else{g=b instanceof A.bq?1:null
h=null}f={e:J.be(b),s:g,r:h,i:e,t:"errorResponse"}
o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
c.H(0,e)
s=o.pop()
break
case 5:c=f
d.a.postMessage(c,A.dA(c))
return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$$1,r)},
$S:131}
A.o9.prototype={
$1(a){var s=this.a.r.H(0,a.i)
if(s!=null)s.abort()},
$S:15}
A.oe.prototype={
$0(){if(!this.a.a){var s={i:this.c,t:"abort"}
this.b.a.postMessage(s,A.dA(s))}},
$S:1}
A.f_.prototype={
j(a){return"Channel to database worker is closed: "+A.q(this.a)},
$iO:1}
A.jQ.prototype={}
A.j3.prototype={
kZ(a,b){var s,r=this
r.a.b.a.aK(new A.om(r),t.P)
s=r.e
s.a=new A.on(r)
s.b=new A.oo(r)
r.iI(r.f,new A.op(r),"notifyCommit")
r.iI(r.r,new A.oq(r),"notifyRollback")},
iI(a,b,c){var s=a.b
s.a=new A.ok(this,a,c,b)
s.b=new A.ol(this,a,b)},
aX(a){var s=0,r=A.i(t.X),q,p=this
var $async$aX=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(p.a.bR({r:a,z:null,i:0,d:p.b,t:"custom"},B.q,null,t.m),$async$aX)
case 3:q=c.r
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aX,r)},
cF(a,b,c){return this.oV(a,b,c,c)},
oV(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f
var $async$cF=A.d(function(e,a0){if(e===1){o.push(a0)
s=p}for(;;)switch(s){case 0:k=m.a
j=m.b
i=t.m
g=A
f=A
s=3
return A.b(k.bR({i:0,d:j,t:"exclusiveLock"},B.q,b,i),$async$cF)
case 3:h=g.R(f.bA(a0.r))
p=4
s=7
return A.b(a.$1(h),$async$cF)
case 7:l=a0
q=l
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:n=[2]
case 5:p=2
s=8
return A.b(k.cf({z:h,i:0,d:j,t:"releaseLock"},B.q,i),$async$cF)
case 8:s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$cF,r)},
cL(a,b,c,d){return this.kz(a,b,c,d)},
kz(a,b,c,d){var s=0,r=A.i(t.ii),q,p=this,o,n,m,l,k
var $async$cL=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:m=A.vH(c)
l=d==null?null:d
s=3
return A.b(p.a.bR({s:a,p:m.a,v:m.b,z:l,r:!0,c:b,i:0,d:p.b,t:"runQuery"},B.bC,null,t.m),$async$cL)
case 3:k=f
l=k.x
o=k.y
n=A.Bh(k)
n.toString
q=new A.kf(l,o,n)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cL,r)},
$iwN:1}
A.om.prototype={
$1(a){var s=this.a,r=s.c
if((r.a.a&30)===0){s=A.u([s.e.n(),s.r.b.n(),s.f.b.n()],t.en)
r.T(A.vp(s,t.z))}},
$S:9}
A.on.prototype={
$0(){var s,r=this.a
if(r.d==null){s=r.a.w
r.d=new A.aq(s,A.p(s).h("aq<1>")).O(new A.oi(r))}if((r.c.a.a&30)===0)r.a.cf({a:!0,i:0,d:r.b,t:"updateRequest"},B.q,t.m)},
$S:0}
A.oi.prototype={
$1(a){var s
if(J.A(a.t,"notifyUpdate")){s=this.a
if(J.A(a.d,s.b))s.e.q(0,new A.ba(B.bu[a.k],a.u,a.r))}},
$S:2}
A.oo.prototype={
$0(){var s=this.a,r=s.d
if(r!=null)r.u()
s.d=null
if((s.c.a.a&30)===0)s.a.cf({a:!1,i:0,d:s.b,t:"updateRequest"},B.q,t.m)},
$S:1}
A.op.prototype={
$1(a){return{a:a,i:0,d:this.a.b,t:"commitRequest"}},
$S:35}
A.oq.prototype={
$1(a){return{a:a,i:0,d:this.a.b,t:"rollbackRequest"}},
$S:35}
A.ok.prototype={
$0(){var s,r,q=this,p=q.b
if(p.a==null){s=q.a
r=s.a.w
p.a=new A.aq(r,A.p(r).h("aq<1>")).O(new A.oj(s,q.c,p))}p=q.a
if((p.c.a.a&30)===0)p.a.cf(q.d.$1(!0),B.q,t.m)},
$S:0}
A.oj.prototype={
$1(a){if(J.A(a.t,this.b)&&J.A(a.d,this.a.b))this.c.b.q(0,null)},
$S:2}
A.ol.prototype={
$0(){var s=this.b,r=s.a
if(r!=null)r.u()
s.a=null
s=this.a
if((s.c.a.a&30)===0)s.a.cf(this.c.$1(!1),B.q,t.m)},
$S:1}
A.jD.prototype={
aZ(a,b){return this.o1(a,b)},
o1(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$aZ=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.x.$1(a.r),$async$aZ)
case 3:q={r:d,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aZ,r)},
fU(a){this.w.q(0,a)}}
A.mw.prototype={
fL(a){var s=0,r=A.i(t.kS),q,p=this,o
var $async$fL=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:o={port:a.a,lockName:a.b}
q=A.Bc(A.BJ(new A.dJ(o.port,o.lockName,null),p.d),0)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$fL,r)}}
A.mx.prototype={
br(a){return this.ot(a)},
ot(a){var s=0,r=A.i(t.w),q
var $async$br=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:q=A.q0(a,null)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$br,r)}}
A.ic.prototype={}
A.m7.prototype={}
A.cy.prototype={
n(){this.gda().n()}}
A.ro.prototype={}
A.ip.prototype={
eq(){var s=0,r=A.i(t.H),q=this
var $async$eq=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=!q.c?2:3
break
case 2:s=4
return A.b(q.a.oG(q.b),$async$eq)
case 4:case 3:return A.f(null,r)}})
return A.h($async$eq,r)},
he(){var s=0,r=A.i(t.H),q=this
var $async$he=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:if(!q.c)q.a.n()
return A.f(null,r)}})
return A.h($async$he,r)}}
A.na.prototype={
oZ(a){var s=this.a,r=this.d
if(this.c)return s.transfer(r)
else return s.slice(0,r)},
lU(a){var s,r,q,p=this,o=p.b
for(s=o;s<a;){s*=2
p.b=s}if(p.c)p.a=p.a.transfer(s)
else{r=v.G
q=new r.ArrayBuffer(s)
new r.Uint8Array(q,0,p.b).set(new r.Uint8Array(p.a,0,o))
p.a=q}}}
A.qa.prototype={
$1(a){var s=new A.l($.m,t.D),r=new A.bV(new A.N(s,t.F))
this.a.a=r
this.b.T(r)
return A.wV(s)},
$S:34}
A.qb.prototype={
$2(a,b){var s,r,q
A.S(a)
s=J.A(a.name,"AbortError")
r=this.a.a
if(r!=null){if((r.a.a.a&30)===0){q=this.b
if(q!=null)q.$0()}}else{q=this.c
if(s)q.b7(new A.bq("Operation was cancelled",null),b)
else q.b7(a,b)}return null},
$S:134}
A.bV.prototype={}
A.ie.prototype={
gn5(){if(this.d.a)return!1
return!this.e||this.r!=null},
bU(a){return this.le(a)},
le(a){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h,g
var $async$bU=A.d(function(b,c){if(b===1){p.push(c)
s=q}for(;;)switch(s){case 0:h=$.hO()
h.toString
m=h
l=null
k=null
j=null
q=3
s=6
return A.b(A.ee(m,n.c,a,null,!1),$async$bU)
case 6:l=c
s=7
return A.b(A.ee(m,n.a,null,n.glL(),!0),$async$bU)
case 7:k=c
s=8
return A.b(A.ee(m,n.b,a,null,!1),$async$bU)
case 8:j=c
h=n.f
h=h==null?null:h.eq()
s=9
return A.b(h instanceof A.l?h:A.bM(h,t.H),$async$bU)
case 9:n.r=new A.Q(k,j)
o.push(5)
s=4
break
case 3:q=2
g=p.pop()
h=k
if(h!=null)h.a.L()
h=j
if(h!=null)h.a.L()
throw g
o.push(5)
s=4
break
case 2:o=[1]
case 4:q=1
h=l
if(h!=null)h.a.L()
s=o.pop()
break
case 5:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$bU,r)},
lM(){this.jN()},
h5(a,b,c){return this.d.eD(new A.mK(this,a,b,c),b,c)},
jN(){return this.d.hm(new A.mL(this),t.H)}}
A.mK.prototype={
$0(){var s,r=this,q=r.a
if(!q.e||q.r!=null)return r.b.$0()
s=r.d
return q.bU(r.c).aK(new A.mJ(r.b,s),s)},
$S(){return this.d.h("0/()")}}
A.mJ.prototype={
$1(a){return this.a.$0()},
$S(){return this.b.h("0/(~)")}}
A.mL.prototype={
$0(){var s,r,q,p=this.a,o=p.r
if(o!=null){s=o.a
r=o.b
q=p.f
if(q!=null)q.he()
s.a.L()
r.a.L()
p.r=null}},
$S:1}
A.dW.prototype={
eD(a,b,c){return this.pd(a,b,c,c)},
hm(a,b){return this.eD(a,null,b)},
pd(a,b,c,d){var s=0,r=A.i(d),q,p=this,o,n,m,l,k,j,i,h,g
var $async$eD=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:h={}
g=b==null
if(J.A(g?null:b.aborted,!0))throw A.a(B.B)
h.a=!1
o=new A.o0(h,p)
if(!p.a){h.a=p.a=!0
q=A.dP(a,c).J(o)
s=1
break}else{n={}
m=new A.l($.m,c.h("l<0>"))
l=new A.N(m,c.h("N<0>"))
n.a=null
h=new A.o_(h,n,l,a,c)
if(!g)n.a=A.aD(b,"abort",new A.nZ(n,p,l,h),!1,t.m)
g=p.b
n=g.a
k=g.c
n[k]=h
n=n.length
k=(k+1&n-1)>>>0
g.c=k
if(g.b===k){j=A.b7(n*2,null,!1,g.$ti.h("1?"))
h=g.a
n=g.b
i=h.length-n
B.c.X(j,0,i,h,n)
B.c.X(j,i,i+g.b,g.a,0)
g.b=0
g.c=g.a.length
g.a=j}++g.d
q=m.J(o)
s=1
break}case 1:return A.f(q,r)}})
return A.h($async$eD,r)}}
A.o0.prototype={
$0(){var s,r,q,p
if(!this.a.a)return
s=this.b
r=s.b
if(!r.gF(0)){s=r.b
if(s===r.c)A.r(A.bW());++r.d
q=r.a
p=q[s]
if(p==null)p=r.$ti.c.a(p)
q[s]=null
r.b=(s+1&q.length-1)>>>0
p.$0()}else s.a=!1},
$S:0}
A.o_.prototype={
$0(){var s,r=this
r.a.a=!0
s=r.b.a
if(s!=null)s.u()
r.c.T(A.dP(r.d,r.e))},
$S:0}
A.nZ.prototype={
$1(a){var s,r=this
r.a.a.u()
s=r.c
if((s.a.a&30)===0){r.b.b.H(0,r.d)
s.ab(B.B)}},
$S:2}
A.cV.prototype={
gjR(){var s,r,q,p,o,n=this,m=t.s,l=A.u([],m)
for(s=n.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q){p=s[q]
B.c.aa(l,A.u([p.a.b,p.b],m))}o={}
o.a=l
o.b=n.b
o.c=n.c
o.d=n.e
o.e=!1
o.f=!1
o.g=n.d
return o}}
A.mW.prototype={
$1(a){if(a!=null)return A.al(a)
return null},
$S:135}
A.ou.prototype={
$1(a){return a},
$S:11}
A.ov.prototype={
$1(a){return a==null?null:a},
$S:137}
A.fu.prototype={
aF(){return"MessageType."+this.b}}
A.ot.prototype={
di(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
ej(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
aZ(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
ct(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
cu(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
cs(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
dl(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
dh(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
jt(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
df(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
dj(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
dm(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
dk(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
dg(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
jq(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
ju(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
jr(a,b){var s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null),r=new A.l($.m,t.e)
r.S(s)
return r},
nq(a,b){var s,r,q=this
switch(a.t){case"open":return q.di(a,b)
case"connect":return q.ej(a,b)
case"custom":return q.aZ(a,b)
case"fileSystemExists":return q.ct(a,b)
case"fileSystemFlush":return q.cu(a,b)
case"fileSystemAccess":return q.cs(a,b)
case"runQuery":return q.dl(a,b)
case"exclusiveLock":return q.dh(a,b)
case"releaseLock":return q.jt(a,b)
case"closeDatabase":return q.df(a,b)
case"openAdditionalConnection":return q.dj(a,b)
case"updateRequest":return q.dm(a,b)
case"rollbackRequest":return q.dk(a,b)
case"commitRequest":return q.dg(a,b)
case"dedicatedCompatibilityCheck":return q.jq(a,b)
case"sharedCompatibilityCheck":return q.ju(a,b)
case"dedicatedInSharedCompatibilityCheck":return q.jr(a,b)
default:s=A.ax(new A.a3(!1,null,null,"Unsupported request "+A.q(a.t)),null)
r=new A.l($.m,t.e)
r.S(s)
return r}}}
A.ck.prototype={
aF(){return"FileSystemImplementation."+this.b}}
A.bw.prototype={
aF(){return"TypeCode."+this.b},
je(a){var s,r=null,q=r
switch(this.a){case 0:q=A.r(A.J("Unsupported type code",r))
break
case 1:a=A.R(A.bA(a))
q=a
break
case 2:q=t.bJ.a(a).toString()
s=A.BY(q,r)
if(s==null)A.r(A.ak("Could not parse BigInt",q,r))
q=s
break
case 3:A.bA(a)
q=a
break
case 4:A.al(a)
q=a
break
case 5:t.Z.a(a)
q=a
break
case 7:A.aY(a)
q=a
break
case 6:break}return q}}
A.cj.prototype={
j3(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c="binding parameter"
a.dR()
s=a.a
r=s.c
s=s.b
q=r.d
p=q.sqlite3_bind_parameter_count(s)
o=this.a
n=o.length
if(n!==p)throw A.a(A.J("Expected "+A.q(p)+" parameters, got "+A.q(n),null))
a.e=this
for(p=this.c,m=v.G,l=t.Z,k=t.bJ,j=0;j<n;j=g){i=p[j]
h=i>=8?B.x:B.I[i]
g=j+1
f=o[j]
switch(h.a){case 1:i=q.sqlite3_bind_int64(s,g,m.BigInt(A.R(A.bA(f))))
if(i!==0)a.bw(i,c)
break
case 2:i=q.sqlite3_bind_int64(s,g,k.a(f))
if(i!==0)a.bw(i,c)
break
case 3:i=q.sqlite3_bind_double(s,g,A.bA(f))
if(i!==0)a.bw(i,c)
break
case 4:e=B.o.av(A.al(f))
i=q.dart_sqlite3_bind_text(s,g,r.fI(e),e.length)
if(i!==0)a.bw(i,c)
break
case 5:l.a(f)
i=q.dart_sqlite3_bind_blob(s,g,r.fI(f),f.length)
if(i!==0)a.bw(i,c)
break
case 6:i=q.sqlite3_bind_null(s,g)
if(i!==0)a.bw(i,c)
break
case 7:d=A.aY(f)?1:0
i=q.sqlite3_bind_int64(s,g,m.BigInt(d))
if(i!==0)a.bw(i,c)
break
case 0:throw A.a(A.P("Unknown type code"))}}},
gk(a){return this.a.length},
sk(a,b){this.iR()},
i(a,b){var s=this.c[b],r=s>=8?B.x:B.I[s]
return r.je(this.a[b])},
l(a,b,c){this.iR()},
iR(){throw A.a(A.P("decodeValues list is unmodifiable"))}}
A.uC.prototype={
$1(a){this.b.transaction.abort()
this.a.a=!1},
$S:15}
A.lN.prototype={
$1(a){this.a.T(this.c.a(this.b.result))},
$S:2}
A.lO.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.ab(s)},
$S:2}
A.lR.prototype={
$1(a){this.a.T(this.c.a(this.b.result))},
$S:2}
A.lS.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.ab(s)},
$S:2}
A.lT.prototype={
$1(a){var s=this.b.error
if(s==null)s=a
this.a.ab(s)},
$S:2}
A.o7.prototype={
nH(){var s,r,q,p
for(s=this.b,r=new A.b6(s,s.r,s.e);r.m();){q=r.d
if(!q.r){q.r=!0
if(!q.f){p=q.a
p.c.d.sqlite3_reset(p.b)
q.f=!0}q=q.a
p=q.c
p.d.sqlite3_finalize(q.b)
p=p.w
if(p!=null){p=p.a
if(p!=null)p.unregister(q.d)}}}s.au(0)}}
A.fe.prototype={
aF(){return"FileType."+this.b}}
A.cv.prototype={
aF(){return"StorageMode."+this.b}}
A.d6.prototype={
j(a){return"Remote error: "+this.a},
$iO:1}
A.bq.prototype={}
A.rp.prototype={
eP(){var s=v.G
if(!("Worker" in s))return null
return new A.rn(new s.Worker(this.a,{name:"sqlite3_worker"}))}}
A.tO.prototype={}
A.rn.prototype={}
A.ua.prototype={
$1(a){return A.S(a.data)},
$S:139}
A.hv.prototype={
u(){var s=this.a
if(s!=null)s.u()
this.a=null}}
A.ek.prototype={
n(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q.c.u()
q.d.u()
q.e.u()
for(p=q.w,o=p.length,n=0;n<p.length;p.length===o||(0,A.a6)(p),++n)p[n].abort()
B.c.au(p)
p=q.f
if(p!=null)p.b.L()
s=2
return A.b(q.a.dd(),$async$n)
case 2:return A.f(null,r)}})
return A.h($async$n,r)},
iJ(a){var s=new v.G.AbortController()
a.onabort=A.uc(new A.rc(s))
this.w.push(s)
return s},
eC(a,b,c,d){var s,r,q,p=this,o=null
if(a==null){s=p.a.f
if(!s.gn5()){r=p.iJ(b)
o=s.h5(c,r.signal,d).J(new A.rg(p,r))}}else{s=p.f
if((s==null?null:s.a)!==a)throw A.a(A.z("Requested operation on inactive lock state."))}if(o==null)o=A.dP(c,d)
q=p.a.z
return q instanceof A.cl?o.J(q.gnV()):o},
oF(a){var s=this,r=s.iJ(a),q=new A.l($.m,t.hy),p=new A.aa(q,t.ho),o=t.H
A.is(s.a.f.h5(new A.rd(s,p),r.signal,o),new A.re(p),o,t.K)
return q.J(new A.rf(s,r))}}
A.rc.prototype={
$0(){return this.a.abort()},
$S:0}
A.rg.prototype={
$0(){B.c.H(this.a.w,this.b)},
$S:1}
A.rd.prototype={
$0(){var s=this.a,r=s.r++,q=new A.l($.m,t.D)
s.f=new A.Q(r,new A.aa(q,t.h))
this.b.T(r)
return q},
$S:3}
A.re.prototype={
$2(a,b){var s=this.a
if((s.a.a&30)===0)s.b7(a,b)},
$S:7}
A.rf.prototype={
$0(){B.c.H(this.a.w,this.b)},
$S:1}
A.ej.prototype={
l6(a,b,c){this.b.a.J(new A.r0(this))},
cn(a,b){return this.lH(a,b)},
lH(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$cn=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.w.j7(a),$async$cn)
case 3:q={r:d.gjR(),i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cn,r)},
jq(a,b){return this.cn(a,b)},
jr(a,b){return this.cn(a,b)},
ju(a,b){return this.cn(a,b)},
ej(a,b){return this.o0(a,b)},
o0(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$ej=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:n=p.w.gie()
n.toString
o={r:a.r,i:0,d:null,t:"connect"}
n.a.postMessage(o,A.dA(o))
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ej,r)},
aZ(a,b){return this.o2(a,b)},
o2(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m,l,k
var $async$aZ=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:k=a.d
s=k!=null?3:5
break
case 3:o=p.hW(k)
n=a.z
m=a.r
s=7
return A.b(o.a.gbu(),$async$aZ)
case 7:s=6
return A.b(d.cr(p,new A.m7(new A.r3(o,n,b),m)),$async$aZ)
case 6:l=d
s=4
break
case 5:s=8
return A.b(p.w.b.cr(p,new A.ic(a)),$async$aZ)
case 8:l=d
case 4:q={r:l,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aZ,r)},
di(a,b){return this.o9(a,b)},
o9(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$di=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.w.y.hm(new A.r6(p,a),t.m),$async$di)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$di,r)},
dl(a,b){return this.od(a,b)},
od(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m
var $async$dl=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
n=o.a
s=3
return A.b(n.gbu(),$async$dl)
case 3:m=d
q=o.eC(a.z,b,new A.r9(m,a,n),t.m)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dl,r)},
dh(a,b){return this.o5(a,b)},
o5(a,b){var s=0,r=A.i(t.m),q,p=this
var $async$dh=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.aW(a).oF(b),$async$dh)
case 3:q={r:d,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dh,r)},
jt(a,b){var s=this.aW(a),r=a.z,q=s.f
if((q==null?null:q.a)!==r)A.r(A.z("Lock to be released is not active."))
q.b.L()
s.f=null
return{r:null,i:a.i,t:"simpleSuccessResponse"}},
dg(a,b){return this.o_(a,b)},
o_(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$dg=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
n=o.e
s=a.a?3:5
break
case 3:s=6
return A.b(p.ci(n,new A.r2(p,o),a),$async$dg)
case 6:q=d
s=1
break
s=4
break
case 5:n.u()
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$dg,r)},
dk(a,b){return this.oc(a,b)},
oc(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$dk=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
n=o.d
s=a.a?3:5
break
case 3:s=6
return A.b(p.ci(n,new A.r8(p,o),a),$async$dk)
case 6:q=d
s=1
break
s=4
break
case 5:n.u()
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$dk,r)},
dm(a,b){return this.oe(a,b)},
oe(a,b){var s=0,r=A.i(t.m),q,p=this,o,n
var $async$dm=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
n=o.c
s=a.a?3:5
break
case 3:s=6
return A.b(p.ci(n,new A.rb(p,o),a),$async$dm)
case 6:q=d
s=1
break
s=4
break
case 5:n.u()
q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$dm,r)},
dj(a,b){return this.oa(a,b)},
oa(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m
var $async$dj=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:m=p.aW(a).a;++m.w
s=3
return A.b(A.uD(),$async$dj)
case 3:o=d
n=o.a
p.w.hD(o.b).x.push(A.xP(m,0))
q={r:n,i:a.i,t:"endpointResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$dj,r)},
df(a,b){return this.nZ(a,b)},
nZ(a,b){var s=0,r=A.i(t.m),q,p=this,o
var $async$df=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
B.c.H(p.x,o)
s=3
return A.b(o.n(),$async$df)
case 3:q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$df,r)},
cu(a,b){return this.o8(a,b)},
o8(a,b){var s=0,r=A.i(t.m),q,p=this,o
var $async$cu=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.aW(a).a.gbP(),$async$cu)
case 3:o=d
s=o instanceof A.cl?4:5
break
case 4:s=6
return A.b(o.jn(),$async$cu)
case 6:case 5:q={r:null,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cu,r)},
cs(a,b){return this.o6(a,b)},
o6(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m,l,k,j
var $async$cs=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
n=B.ae[a.f]
m=a.b
l=o
k=b
j=A
s=4
return A.b(o.a.gbP(),$async$cs)
case 4:s=3
return A.b(l.eC(null,k,new j.r4(d,n,m,a),t.m),$async$cs)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cs,r)},
ct(a,b){return this.o7(a,b)},
o7(a,b){var s=0,r=A.i(t.m),q,p=this,o,n,m,l
var $async$ct=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=p.aW(a)
n=o
m=b
l=A
s=4
return A.b(o.a.gbP(),$async$ct)
case 4:s=3
return A.b(n.eC(null,m,new l.r5(d,a),t.y),$async$ct)
case 3:q={r:d,i:a.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ct,r)},
ci(a,b,c){return this.kI(a,b,c)},
kI(a,b,c){var s=0,r=A.i(t.m),q,p
var $async$ci=A.d(function(d,e){if(d===1)return A.e(e,r)
for(;;)switch(s){case 0:s=a.a==null?3:4
break
case 3:p=a
s=5
return A.b(b.$0(),$async$ci)
case 5:p.a=e
case 4:q={r:null,i:c.i,t:"simpleSuccessResponse"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$ci,r)},
fU(a){},
aX(a){var s=0,r=A.i(t.X),q,p=this
var $async$aX=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(p.cf({r:a,z:null,i:0,d:null,t:"custom"},B.q,t.m),$async$aX)
case 3:q=c.r
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aX,r)},
hW(a){return B.c.jm(this.x,new A.r_(a))},
aW(a){var s=a.d
if(s!=null)return this.hW(s)
else throw A.a(A.J("Request requires database id",null))},
$iwK:1}
A.r0.prototype={
$0(){var s=0,r=A.i(t.H),q=this,p,o,n
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:p=q.a.x,o=p.length,n=0
case 2:if(!(n<p.length)){s=4
break}s=5
return A.b(p[n].n(),$async$$0)
case 5:case 3:p.length===o||(0,A.a6)(p),++n
s=2
break
case 4:B.c.au(p)
return A.f(null,r)}})
return A.h($async$$0,r)},
$S:3}
A.r3.prototype={
$1$1(a,b){return this.a.eC(this.b,this.c,a,b)},
$1(a){return this.$1$1(a,t.z)},
$S:140}
A.r6.prototype={
$0(){var s=0,r=A.i(t.m),q,p=2,o=[],n=this,m,l,k,j,i,h,g
var $async$$0=A.d(function(a,b){if(a===1){o.push(b)
s=p}for(;;)switch(s){case 0:j=n.a
i=j.w
h=n.b
s=3
return A.b(i.br(h.u),$async$$0)
case 3:m=null
l=null
p=5
m=i.nU(h.d,A.Ay(h.s),h.c,h.a)
s=8
return A.b(h.o?m.gbP():m.gbu(),$async$$0)
case 8:l=A.xP(m,null)
j.x.push(l)
i={r:m.b,i:h.i,t:"simpleSuccessResponse"}
q=i
s=1
break
p=2
s=7
break
case 5:p=4
g=o.pop()
s=m!=null?9:10
break
case 9:B.c.H(j.x,l)
s=11
return A.b(m.dd(),$async$$0)
case 11:case 10:throw g
s=7
break
case 4:s=2
break
case 7:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$0,r)},
$S:141}
A.r9.prototype={
$0(){var s,r,q,p,o=null,n="This database has already been closed",m=this.a.gda(),l=this.b
if(l.c&&m.gd8())throw A.a(A.z("Database is not in a transaction"))
s=l.p
r=l.v
r.toString
q=new A.cj(s,r,A.aV(r,0,o))
s=this.c
if(l.r){p=s.ky(m,l.s,q)
p.i=l.i
p.x=m.gd8()
if(m.r)A.r(A.z(n))
l=m.b
p.y=A.R(v.G.Number(l.a.d.sqlite3_last_insert_rowid(l.b)))
return p}else{s.nN(m,l.s,q)
s=m.gd8()
if(m.r)A.r(A.z(n))
r=m.b
return A.z4(s,o,A.R(v.G.Number(r.a.d.sqlite3_last_insert_rowid(r.b))),l.i,o,o,o)}},
$S:19}
A.r2.prototype={
$0(){var s=0,r=A.i(t.ey),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.b
s=3
return A.b(o.a.gbu(),$async$$0)
case 3:q=b.gda().f3().gbB().O(new A.r1(p.a,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:37}
A.r1.prototype={
$1(a){var s={d:this.b.b,t:"notifyCommit"}
this.a.a.postMessage(s,A.dA(s))},
$S:22}
A.r8.prototype={
$0(){var s=0,r=A.i(t.ey),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.b
s=3
return A.b(o.a.gbu(),$async$$0)
case 3:q=b.gda().mv().gbB().O(new A.r7(p.a,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:37}
A.r7.prototype={
$1(a){var s={d:this.b.b,t:"notifyRollback"}
this.a.a.postMessage(s,A.dA(s))},
$S:22}
A.rb.prototype={
$0(){var s=0,r=A.i(t.ha),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.b
s=3
return A.b(o.a.gbu(),$async$$0)
case 3:q=b.gda().iT().gbB().O(new A.ra(p.a,o))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:144}
A.ra.prototype={
$1(a){var s={k:a.a.a,u:a.b,r:a.c,d:this.b.b,t:"notifyUpdate"}
this.a.a.postMessage(s,A.dA(s))},
$S:40}
A.r4.prototype={
$0(){var s,r,q,p=this,o=p.a.ce(new A.fF(A.yu(p.b)),4).a
try{q=p.c
if(q!=null){s=q
o.dE(s.byteLength)
o.cJ(A.aV(s,0,null),0)
q={r:null,i:p.d.i,t:"simpleSuccessResponse"}
return q}else{q=o.cI()
r=new Uint8Array(q)
o.eK(r,0)
q={r:t.a.a(J.zX(r)),i:p.d.i,t:"simpleSuccessResponse"}
return q}}finally{o.eI()}},
$S:19}
A.r5.prototype={
$0(){return this.a.eH(A.yu(B.ae[this.b.f]),0)===1},
$S:42}
A.r_.prototype={
$1(a){return a.b===this.a},
$S:147}
A.ig.prototype={
gbP(){var s=0,r=A.i(t.e6),q,p=this,o
var $async$gbP=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.y
s=3
return A.b(o==null?p.y=A.dP(new A.mO(p),t.H):o,$async$gbP)
case 3:o=p.z
o.toString
q=o
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$gbP,r)},
gbu(){var s=0,r=A.i(t.u),q,p=this,o
var $async$gbu=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.x
s=3
return A.b(o==null?p.x=A.dP(new A.mN(p),t.u):o,$async$gbu)
case 3:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$gbu,r)},
dd(){var s=0,r=A.i(t.H),q=this
var $async$dd=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=--q.w===0?2:3
break
case 2:s=4
return A.b(q.n(),$async$dd)
case 4:case 3:return A.f(null,r)}})
return A.h($async$dd,r)},
n(){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k,j
var $async$n=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:j=q.a.r
j.toString
s=2
return A.b(j,$async$n)
case 2:p=b
o=q.x
s=o!=null?3:4
break
case 3:s=5
return A.b(o,$async$n)
case 5:n=b
j=q.r
if(j!=null)j.nH()
n.n()
m=q.z
if(m!=null){j=p.a
l=j.b
A.wS(m)
k=l.a.get(m)
if(k==null)A.r(A.z("vfs has not been registered"))
l.l(0,m,null)
j.a.d.dart_sqlite3_unregister_vfs(k)}case 4:j=q.Q
j=j==null?null:j.$0()
s=6
return A.b(j instanceof A.l?j:A.bM(j,t.H),$async$n)
case 6:q.f.jN()
return A.f(null,r)}})
return A.h($async$n,r)},
ip(a,b){var s,r,q,p,o=this.r,n=o==null
if(n)s=null
else{r=o.b
q=r.H(0,b)
if(q!=null)r.l(0,b,q)
s=q}if(s!=null)return new A.Q(s,!0)
p=a.jH(b,!0)
if(!n){p.dR()
n=p.a
n=n.c.d.sqlite3_stmt_isexplain(n.b)===0}else n=!1
if(n){n=o.b
if(n.a===o.a)n.H(0,new A.b5(n,A.p(n).h("b5<1>")).gai(0)).n()
n.l(0,p.d,p)
return new A.Q(p,!0)}return new A.Q(p,!1)},
nN(a,b,c){var s,r,q
if(c.gk(0)===0)return a.aY(b,B.n)
else{s=null
r=null
q=this.ip(a,b)
s=q.a
r=q.b
try{s.nP(new A.f7(c.gj2()))}finally{if(r)s.dw()
else s.n()}}},
ky(a,b,c){var s,r=null,q=null,p=this.ip(a,b)
r=p.a
q=p.b
try{s=A.Bg(r,c)
return s}finally{if(q)r.dw()
else r.n()}}}
A.mO.prototype={
$0(){var s=0,r=A.i(t.H),q=this,p,o,n,m,l,k
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:l=q.a
k=l.d
case 2:switch(k.a){case 0:s=4
break
case 1:s=5
break
case 2:s=6
break
case 3:s=7
break
case 4:s=8
break
default:s=3
break}break
case 4:s=9
return A.b(A.oz("drift_db/"+l.c,"vfs-web-"+l.b),$async$$0)
case 9:p=b
l.z=p
l.Q=p.gaG()
s=3
break
case 5:case 6:s=10
return A.b(A.iq("drift_db/"+l.c,k===B.H,"vfs-web-"+l.b),$async$$0)
case 10:o=b
l.f.f=o
n=o.a
l.z=n
l.Q=n.gaG()
s=3
break
case 7:s=11
return A.b(A.iv(l.c,"vfs-web-"+l.b,!1),$async$$0)
case 11:m=b
l.z=m
l.Q=m.gaG()
s=3
break
case 8:l.z=A.vr("vfs-web-"+l.b,null)
s=3
break
case 3:return A.f(null,r)}})
return A.h($async$$0,r)},
$S:3}
A.mN.prototype={
$0(){var s=0,r=A.i(t.u),q,p=this,o,n,m,l,k,j
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:k=p.a
j=k.a.r
j.toString
s=3
return A.b(j,$async$$0)
case 3:o=b
s=4
return A.b(k.gbP(),$async$$0)
case 4:n=b
o.jw()
j=o.a
m=j.b
A.wS(n)
if(m.a.get(n)!=null)A.r(A.z("vfs has already been registered"))
j=j.a
l=j.d.dart_sqlite3_register_vfs(j.d7(B.o.av(n.a),1),n,0)
if(l===0)A.r(A.z("could not register vfs"))
m.l(0,n,l)
s=5
return A.b(k.f.h5(new A.mM(k,o),null,t.u),$async$$0)
case 5:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:55}
A.mM.prototype={
$0(){var s=this.a
return s.a.b.h9(this.b,"/database","vfs-web-"+s.b,s.e)},
$S:55}
A.qp.prototype={
gie(){var s,r=this,q=r.Q
if(q===$){s=r.a.gna().eP()
r.Q!==$&&A.wq()
r.Q=s
q=s}return q},
cv(){var s=0,r=A.i(t.H),q=1,p=[],o=[],n=this,m,l,k,j,i,h
var $async$cv=A.d(function(a,b){if(a===1){p.push(b)
s=q}for(;;)switch(s){case 0:h=new A.bP(A.bd(A.D5(n.a),"stream",t.K))
q=2
j=v.G
case 5:s=7
return A.b(h.m(),$async$cv)
case 7:if(!b){s=6
break}m=h.gp()
s=J.A(m.t,"connect")?8:10
break
case 8:i=m.r
l=new A.dJ(i.port,i.lockName,null)
n.hD(l)
s=9
break
case 10:s=A.EG(m.t)?11:12
break
case 11:s=13
return A.b(n.j7(m),$async$cv)
case 13:k=b
j.postMessage(k.gjR())
case 12:case 9:s=5
break
case 6:o.push(4)
s=3
break
case 2:o=[1]
case 3:q=1
s=14
return A.b(h.u(),$async$cv)
case 14:s=o.pop()
break
case 4:return A.f(null,r)
case 1:return A.e(p.at(-1),r)}})
return A.h($async$cv,r)},
hD(a){var s=this,r=A.C0(a,s.d++,s)
s.c.push(r)
r.b.a.J(new A.qq(s,r))
return r},
j7(a){return this.x.hm(new A.qr(this,a),t.p6)},
br(a){return this.ou(a)},
ou(a){var s=0,r=A.i(t.H),q=this,p,o,n,m
var $async$br=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:n=v.G
m=new n.URL(a,A.S(n.location).href).href
n=q.r
s=n!=null?2:4
break
case 2:p=q.w
if(p!==m)throw A.a(A.z("Workers only support a single sqlite3 wasm module, provided different URI (has "+A.q(p)+", got "+m+")"))
s=5
return A.b(t.jN.b(n)?n:A.bM(n,t.he),$async$br)
case 5:s=3
break
case 4:o=A.is(q.b.br(m),new A.qs(q),t.w,t.K)
q.r=o
s=6
return A.b(o,$async$br)
case 6:q.w=m
case 3:return A.f(null,r)}})
return A.h($async$br,r)},
nU(a,b,c,d){var s,r,q,p,o,n
for(s=this.e,r=new A.b6(s,s.r,s.e);r.m();){q=r.d
p=q.w
if(p!==0&&q.c===a&&q.d===b){q.w=p+1
return q}}r=this.f++
q="pkg-sqlite3-web-"+a
p=b===B.H||b===B.a8
o=A.nO(t.cj)
n=c===0?null:new A.o7(c,A.vx(null,null,t.N,t.fw))
n=new A.ig(this,r,a,b,d,new A.ie(q+"-outer",q,q+"-tmp",new A.dW(o),p),n)
s.l(0,r,n)
return n}}
A.qq.prototype={
$0(){var s=this.a,r=s.c
B.c.H(r,this.b)
if(r.length===0)s.a.n()
return null},
$S:0}
A.qr.prototype={
$0(){var s=0,r=A.i(t.p6),q,p=this,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a
var $async$$0=A.d(function(a0,a1){if(a0===1)return A.e(a1,r)
for(;;)switch(s){case 0:d=p.b
c=d.d
s=J.A(d.t,"dedicatedCompatibilityCheck")||J.A(d.t,"dedicatedInSharedCompatibilityCheck")?3:5
break
case 3:s=6
return A.b(A.cH(),$async$$0)
case 6:o=a1
n=o.a
m=o.b
l=m
k=n
s=4
break
case 5:k=!1
l=!1
case 4:b=J.A(d.t,"dedicatedCompatibilityCheck")||J.A(d.t,"sharedCompatibilityCheck")
if(b){s=7
break}else a1=b
s=8
break
case 7:s=9
return A.b(A.kQ(),$async$$0)
case 9:case 8:j=a1
i=A.bs(t.cU)
s=J.A(d.t,"sharedCompatibilityCheck")?10:12
break
case 10:h=p.a.gie()
g=h!=null
s=g?13:14
break
case 13:d={d:c,i:0,t:"dedicatedInSharedCompatibilityCheck"}
f=A.dA(d)
n=h.a
n.postMessage(d,f)
b=A
a=A
s=15
return A.b(new A.ep(n,"message",!1,t.d4).gai(0),$async$$0)
case 15:e=b.Af(a.S(a1.data))
k=e.c
l=e.d
i.aa(0,e.a)
case 14:s=11
break
case 12:g=!1
case 11:s=k?16:17
break
case 16:b=J
s=18
return A.b(A.eS(),$async$$0)
case 18:d=b.Z(a1)
case 19:if(!d.m()){s=20
break}i.q(0,new A.Q(B.an,d.gp()))
s=19
break
case 20:case 17:s=j&&c!=null?21:22
break
case 21:s=23
return A.b(A.uB(c),$async$$0)
case 23:if(a1)i.q(0,new A.Q(B.ao,c))
case 22:d=A.ap(i,i.$ti.c)
q=new A.cV(d,g,k,l,j)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:149}
A.qs.prototype={
$2(a,b){this.a.r=null
throw A.a(a)},
$S:150}
A.iJ.prototype={
j(a){return"LockError: "+this.a}}
A.tj.prototype={
bJ(a,b,c){return this.oy(a,b,c,c)},
oy(a,b,c,d){var s=0,r=A.i(d),q,p=this,o
var $async$bJ=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:if($.m.i(0,p)!=null)throw A.a(new A.iJ("Recursive lock is not allowed"))
o=t.X
q=$.m.jo(A.bE([p,!0],o,o)).bv(new A.to(p,b,a,c),c.h("0/"))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bJ,r)}}
A.tk.prototype={
$1(a){},
$S:13}
A.to.prototype={
$0(){return this.ko(this.d)},
ko(a){var s=0,r=A.i(a),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c
var $async$$0=A.d(function(b,a0){if(b===1){o.push(a0)
s=p}for(;;)switch(s){case 0:j={}
i=m.a
h=i.a
g=j.a=!1
f=$.m
e=t.D
d=t.F
c=new A.N(new A.l(f,e),d)
i.a=c.a
p=3
s=h!=null?6:7
break
case 6:l=new A.N(new A.l(f,e),d)
h.aK(new A.tl(j,l),t.P)
f=m.b
if(f!=null)f.J(new A.tm(l))
s=8
return A.b(l.a,$async$$0)
case 8:case 7:s=9
return A.b(m.c.$0(),$async$$0)
case 9:f=a0
q=f
n=[1]
s=4
break
n.push(5)
s=4
break
case 3:n=[2]
case 4:p=2
k=new A.tp(i,c)
if(h!=null?!j.a:g)h.aK(new A.tn(k),t.P).lN()
else k.$0()
s=n.pop()
break
case 5:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$$0,r)},
$S(){return this.d.h("o<0>()")}}
A.tl.prototype={
$1(a){var s
this.a.a=!0
s=this.b
if((s.a.a&30)===0)s.L()},
$S:9}
A.tm.prototype={
$0(){var s=this.a
if((s.a.a&30)===0)s.b7(new A.bC("lock"),A.fH())},
$S:1}
A.tp.prototype={
$0(){var s=this.a,r=this.b
if(s.a===r.a)s.a=null
r.L()},
$S:0}
A.tn.prototype={
$1(a){this.a.$0()},
$S:9}
A.jh.prototype={}
A.ji.prototype={
oQ(a,b){return this.jL(new A.oG(this,a,b),"readTransaction()",null,b)}}
A.oG.prototype={
$1(a){return this.kc(a,this.c)},
kc(a,b){var s=0,r=A.i(b),q,p=this
var $async$$1=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(A.eQ(a,p.b,!1,p.c),$async$$1)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S(){return this.c.h("o<0>(aB)")}}
A.bC.prototype={
j(a){return"A call to "+this.a+" has been aborted"},
$iO:1}
A.jt.prototype={
bx(a,b){return this.kq(a,b)},
kq(a,b){var s=0,r=A.i(t.oy),q,p=this,o
var $async$bx=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.aC(a,b),$async$bx)
case 3:o=d
q=o.gai(o)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bx,r)},
aS(a,b){return this.ku(a,b)},
ku(a,b){var s=0,r=A.i(t.x),q,p=this,o
var $async$aS=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:o=A
s=3
return A.b(p.aC(a,b),$async$aS)
case 3:q=o.AI(d)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aS,r)},
eb(){var s=0,r=A.i(t.H),q=this
var $async$eb=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=2
return A.b(q.by(),$async$eb)
case 2:if(!b)throw A.a(A.jj(null,null,0,"Dangling transaction detected. If you want to use BEGIN statements manually, COMMIT or ROLLBACK them before returning from writeLock.",null,null,null))
return A.f(null,r)}})
return A.h($async$eb,r)},
$iaB:1}
A.fC.prototype={
cS(){if(this.c)A.r(A.z("This context to a callback is no longer open. Make sure to await all statements on a database to avoid a context still being used after its callback has finished."))
if(this.b)throw A.a(A.z("The context from the callback was locked, e.g. due to a nested transaction."))},
bx(a,b){return this.kp(a,b)},
kp(a,b){var s=0,r=A.i(t.oy),q,p=this
var $async$bx=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cS()
q=p.a.bx(a,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$bx,r)},
aC(a,b){return this.kr(a,b)},
eM(a){return this.aC(a,B.n)},
kr(a,b){var s=0,r=A.i(t.G),q,p=this
var $async$aC=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cS()
s=3
return A.b(p.a.aC(a,b),$async$aC)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aC,r)},
aS(a,b){return this.kt(a,b)},
dH(a){return this.aS(a,B.n)},
kt(a,b){var s=0,r=A.i(t.x),q,p=this
var $async$aS=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cS()
q=p.a.aS(a,b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aS,r)},
$iaB:1}
A.fD.prototype={
aY(a,b){return this.nO(a,b)},
jh(a){return this.aY(a,B.n)},
nO(a,b){var s=0,r=A.i(t.G),q,p=this
var $async$aY=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:p.cS()
s=3
return A.b(p.a.aY(a,b),$async$aY)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aY,r)},
b0(a,b){return this.pi(a,b,b)},
pi(a2,a3,a4){var s=0,r=A.i(a4),q,p=2,o=[],n=[],m=this,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
var $async$b0=A.d(function(a5,a6){if(a5===1){o.push(a6)
s=p}for(;;)switch(s){case 0:m.cS()
l=null
k=null
j=null
f=m.d
e=A.Bk(f)
l=e.a
k=e.b
j=e.c
i=null
d=m.a
if(f===0){c=new A.cd(d.a,d.b,null)
c.d=!0}else c=d
h=c
p=4
m.b=!0
s=7
return A.b(d.aY(l,B.n),$async$b0)
case 7:i=new A.fD(f+1,h)
s=8
return A.b(a2.$1(i),$async$b0)
case 8:g=a6
s=9
return A.b(h.aY(k,B.n),$async$b0)
case 9:q=g
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:p=3
a0=o.pop()
p=11
s=14
return A.b(h.aY(j,B.n),$async$b0)
case 14:p=3
s=13
break
case 11:p=10
a1=o.pop()
s=13
break
case 10:s=3
break
case 13:throw a0
n.push(6)
s=5
break
case 3:n=[2]
case 5:p=2
m.b=!1
f=i
if(f!=null)f.c=!0
s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$b0,r)},
$iaK:1}
A.jg.prototype={
jL(a,b,c,d){return this.mV(a,null,b,d)},
jK(a,b,c){return this.jL(a,b,null,c)},
aC(a,b){return this.jK(new A.oE(a,b),"getAll()",t.G)},
aS(a,b){return this.jK(new A.oF(a,b),"getOptional()",t.x)},
dH(a){return this.aS(a,B.n)},
$iaB:1,
$iaK:1}
A.oE.prototype={
$1(a){return this.ka(a)},
ka(a){var s=0,r=A.i(t.G),q,p=this
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:q=a.aC(p.a,p.b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:151}
A.oF.prototype={
$1(a){return this.kb(a)},
kb(a){var s=0,r=A.i(t.x),q,p=this
var $async$$1=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:q=a.aS(p.a,p.b)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S:152}
A.K.prototype={
D(a,b){if(b==null)return!1
return b instanceof A.K&&B.b0.bG(b.a,this.a)},
gv(a){return A.B2(this.a)},
j(a){return"UpdateNotification<"+this.a.j(0)+">"},
cH(a){return new A.K(this.a.cH(a.a))},
fM(a){var s
for(s=this.a,s=s.gA(s);s.m();)if(a.U(0,s.gp().toLowerCase()))return!0
return!1}}
A.pL.prototype={
$2(a,b){return a.cH(b)},
$S:153}
A.pK.prototype={
$1(a){return new A.ce(new A.pJ(this.a),a,A.p(a).h("ce<D.T>"))},
$S:154}
A.pJ.prototype={
$1(a){return a.fM(this.a)},
$S:155}
A.ur.prototype={
$1(a){var s,r,q,p,o=this,n={}
n.a=n.b=null
n.c=!1
s=new A.us(n,a)
r=A.xO()
q=new A.ut(n,a,s,r)
r.b=new A.un(n,o.a,q)
p=o.c.az(new A.uu(n,o.b,q,o.f),new A.uv(s,a),new A.uw(s,a))
a.e=new A.uo(n)
a.f=new A.up(n,r,q)
a.r=new A.uq(n,p)
a.q(0,o.d)
r.dW().$0()},
$S(){return this.f.h("~(bZ<0>)")}}
A.us.prototype={
$0(){var s,r=this.a,q=r.b
if(q!=null){r.b=null
this.b.n2(q)
s=r.a
if(s!=null)s.u()
r.a=null
return!0}else return!1},
$S:42}
A.ut.prototype={
$0(){var s,r,q=this,p=q.a
if(p.a==null){s=q.b
r=s.b
s=!((r&1)!==0?(s.ga6().e&4)!==0:(r&2)===0)}else s=!1
if(s)if(q.c.$0()){s=q.b
r=s.b
if((r&1)!==0?(s.ga6().e&4)!==0:(r&2)===0)p.c=!0
else q.d.dW().$0()}},
$S:0}
A.un.prototype={
$0(){var s=this.a
s.a=A.pA(this.b,new A.um(s,this.c))},
$S:0}
A.um.prototype={
$0(){this.a.a=null
this.b.$0()},
$S:0}
A.uu.prototype={
$1(a){var s,r=this.a,q=r.b
A:{if(q==null){s=a
break A}s=this.b.$2(q,a)
break A}r.b=s
this.c.$0()},
$S(){return this.d.h("~(0)")}}
A.uw.prototype={
$2(a,b){this.a.$0()
this.b.n_(a,b)},
$S:6}
A.uv.prototype={
$0(){this.a.$0()
this.b.j8()},
$S:0}
A.uo.prototype={
$0(){var s=this.a,r=s.a,q=r==null
s.c=!q
if(!q)r.u()
s.a=null},
$S:0}
A.up.prototype={
$0(){if(this.a.c)this.b.dW().$0()
else this.c.$0()},
$S:0}
A.uq.prototype={
$0(){var s=0,r=A.i(t.H),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.a.a
if(o!=null)o.u()
q=p.b.u()
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:3}
A.pz.prototype={
$0(){this.a.q3()},
$S:1}
A.px.prototype={
$1(a){this.a.q(0,a.b)},
$S:40}
A.pu.prototype={
$0(){var s,r,q,p,o,n,m,l,k,j,i
for(s=this.a,r=s.length,q=this.b,p=t.N,o=0;o<s.length;s.length===r||(0,A.a6)(s),++o){n=s[o]
n.b.aa(0,q)
m=n.a
l=m.b
k=(l&1)!==0
if(!(k?(m.ga6().e&4)!==0:(l&2)===0)){j=n.b
if(j.a!==0){if(l>=4)A.r(m.ap())
if(k)m.a1(j)
else if((l&3)===0){m=m.bX()
j=new A.bx(j)
i=m.c
if(i==null)m.b=m.c=j
else{i.sbs(j)
m.c=j}}n.b=A.bs(p)}}}q.au(0)},
$S:0}
A.pv.prototype={
$0(){this.a.au(0)},
$S:0}
A.pr.prototype={
$1(a){var s,r,q=this,p=q.b
p.push(a)
if(p.length===1){p=q.c
s=p.iT()
r=s.w
s=r==null?s.w=s.i7(!0):r
q.a.a=A.u([s.O(q.d),p.f3().gbB().O(new A.ps(q.e)),p.f3().gbB().O(new A.pt(q.f))],t.bO)}},
$S:48}
A.ps.prototype={
$1(a){return this.a.$0()},
$S:22}
A.pt.prototype={
$1(a){return this.a.$0()},
$S:22}
A.py.prototype={
$1(a){var s,r,q=this.b
B.c.H(q,a)
if(q.length===0)for(q=this.a.a,s=q.length,r=0;r<q.length;q.length===s||(0,A.a6)(q),++r)q[r].u()},
$S:48}
A.pw.prototype={
$1(a){var s=new A.dv(a,A.bs(t.N))
this.a.$1(s)
a.f=s.gn0()
a.r=new A.pq(this.b,s)},
$S:157}
A.pq.prototype={
$0(){return this.a.$1(this.b)},
$S:0}
A.dv.prototype={
n1(){var s=this.b
if(s.a!==0){this.a.q(0,s)
this.b=A.bs(t.N)}}}
A.jA.prototype={
by(){var s=0,r=A.i(t.y),q,p=this,o,n
var $async$by=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:n=A
s=3
return A.b(p.a.aX({rawKind:"getAutoCommit"}),$async$by)
case 3:o=n.w3(b)
if(o==null)o=null
q=o===!0
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$by,r)},
mV(a,b,c,d){return this.c_(new A.q6(a,d),b,c,d)},
b0(a,b){return this.lV(new A.q9(a,b),null,b)},
e5(a,b,c,d){return this.mX(a,b,c,d,d)},
mW(a,b,c){return this.e5(a,b,null,c)},
mX(a,b,c,d,e){var s=0,r=A.i(e),q,p=this
var $async$e5=A.d(function(f,g){if(f===1)return A.e(g,r)
for(;;)switch(s){case 0:s=3
return A.b(p.c_(new A.q7(a,d),b,c,d),$async$e5)
case 3:q=g
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$e5,r)},
c_(a,b,c,d){return this.lW(a,b,c,d,d)},
lV(a,b,c){return this.c_(a,b,null,c)},
lW(a,b,c,d,e){var s=0,r=A.i(e),q,p=this,o,n
var $async$c_=A.d(function(f,g){if(f===1)return A.e(g,r)
for(;;)switch(s){case 0:n=p.b
s=n!=null?3:5
break
case 3:s=6
return A.b(n.bJ(new A.q4(p,a,d),b,d),$async$c_)
case 6:q=g
s=1
break
s=4
break
case 5:o=p.a.cF(new A.q5(p,a,d),b,d)
s=7
return A.b(A.D6(o,c==null?"lock":c,d),$async$c_)
case 7:q=g
s=1
break
case 4:case 1:return A.f(q,r)}})
return A.h($async$c_,r)},
$ivK:1}
A.q6.prototype={
$1(a){return A.ow(a,this.a,this.b)},
$S(){return this.b.h("o<0>(cd)")}}
A.q9.prototype={
$1(a){var s=this.b
return A.fE(a,new A.q8(this.a,s),s)},
$S(){return this.b.h("o<0>(cd)")}}
A.q8.prototype={
$1(a){return this.ki(a,this.b)},
ki(a,b){var s=0,r=A.i(b),q,p=this
var $async$$1=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(a.b0(p.a,p.b),$async$$1)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S(){return this.b.h("o<0>(aK)")}}
A.q7.prototype={
$1(a){return A.fE(a,this.a,this.b)},
$S(){return this.b.h("o<0>(cd)")}}
A.q4.prototype={
$0(){return this.kh(this.c)},
kh(a){var s=0,r=A.i(a),q,p=this
var $async$$0=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:s=3
return A.b(p.b.$1(new A.cd(p.a,null,null)),$async$$0)
case 3:q=c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S(){return this.c.h("o<0>()")}}
A.q5.prototype={
$1(a){return this.kg(a,this.c)},
kg(a,b){var s=0,r=A.i(b),q,p=this
var $async$$1=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:s=3
return A.b(p.b.$1(new A.cd(p.a,a,null)),$async$$1)
case 3:q=d
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$1,r)},
$S(){return this.c.h("o<0>(c)")}}
A.cd.prototype={
aC(a,b){return this.ks(a,b)},
ks(a,b){var s=0,r=A.i(t.G),q,p=this
var $async$aC=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:q=A.xA(p.c,"getAll",new A.tI(p,a,b),b,a,t.G)
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$aC,r)},
by(){var s=0,r=A.i(t.y),q,p=this
var $async$by=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:q=p.a.by()
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$by,r)},
aY(a,b){return A.xA(this.c,"execute",new A.tG(this,a,b),b,a,t.G)}}
A.tI.prototype={
$0(){var s=0,r=A.i(t.G),q,p=this
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:s=3
return A.b(A.kU(new A.tH(p.a,p.b,p.c),t.G),$async$$0)
case 3:q=b
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:21}
A.tH.prototype={
$0(){var s=0,r=A.i(t.G),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.a
s=3
return A.b(o.a.a.cL(p.b,o.d,p.c,o.b),$async$$0)
case 3:q=b.c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:21}
A.tG.prototype={
$0(){return A.kU(new A.tF(this.a,this.b,this.c),t.G)},
$S:21}
A.tF.prototype={
$0(){var s=0,r=A.i(t.G),q,p=this,o
var $async$$0=A.d(function(a,b){if(a===1)return A.e(b,r)
for(;;)switch(s){case 0:o=p.a
s=3
return A.b(o.a.a.cL(p.b,o.d,p.c,o.b),$async$$0)
case 3:q=b.c
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$$0,r)},
$S:21}
A.ub.prototype={
$2(a,b){return A.il(new A.bC(this.a),b)},
$S:159}
A.i3.prototype={
gp7(){var s=t.d4,r=s.h("aM<D.T,K?>"),q=r.h("ce<D.T>")
return new A.cS(new A.ce(new A.ll(),new A.aM(new A.lm(),new A.ep(this.b,"message",!1,s),r),q),q.h("cS<D.T,K>"))},
ao(a){this.b.postMessage(A.BZ(a))}}
A.lm.prototype={
$1(a){var s,r,q=A.S(a.data)
if(J.A(q.a,0)){s=t.c.a(q.b)
r=t.k.b(s)?s:new A.ag(s,A.a5(s).h("ag<1,j>"))
return new A.K(J.dE(r,new A.lk(),t.N).dD(0))}else return null},
$S:161}
A.lk.prototype={
$1(a){return a},
$S:11}
A.ll.prototype={
$1(a){return a!=null},
$S:162}
A.qU.prototype={
$1(a){return a},
$S:11}
A.bS.prototype={
aF(){return"CustomDatabaseMessageKind."+this.b}}
A.ju.prototype={
fV(a){var s=0,r=A.i(t.X),q,p=this,o,n
var $async$fV=A.d(function(b,c){if(b===1)return A.e(c,r)
for(;;)switch(s){case 0:A.S(a)
if(A.mV(B.af,a.rawKind)===B.F){o=a.rawParameters
o=B.c.b9(o,new A.pG(),t.N).dD(0)
n=p.b.i(0,a.rawSql)
if(n!=null)n.q(0,new A.K(o))}q=null
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$fV,r)},
p8(a){var s=null,r=B.b.j(this.a++),q=A.bI(s,s,s,s,!1,t.d)
this.b.l(0,r,q)
q.d=new A.pH(a,r)
q.r=new A.pI(this,a,r)
return new A.a4(q,A.p(q).h("a4<1>"))}}
A.pG.prototype={
$1(a){return A.al(a)},
$S:47}
A.pH.prototype={
$0(){this.a.aX(A.vm(B.E,this.b,[!0]))},
$S:0}
A.pI.prototype={
$0(){var s=this.c
this.b.aX(A.vm(B.E,s,[!1]))
this.a.b.H(0,s)},
$S:1}
A.qc.prototype={
bJ(a,b,c){if("locks" in v.G.navigator)return this.d6(a,b,c)
else return this.a.bJ(a,b,c)},
ox(a,b){return this.bJ(a,null,b)},
d6(a,b,c){return this.mO(a,b,c,c)},
mO(a,b,c,d){var s=0,r=A.i(d),q,p=2,o=[],n=[],m=this,l,k
var $async$d6=A.d(function(e,f){if(e===1){o.push(f)
s=p}for(;;)switch(s){case 0:s=3
return A.b(m.lG(b),$async$d6)
case 3:k=f
p=4
s=7
return A.b(a.$0(),$async$d6)
case 7:l=f
q=l
n=[1]
s=5
break
n.push(6)
s=5
break
case 4:n=[2]
case 5:p=2
k.a.L()
s=n.pop()
break
case 6:case 1:return A.f(q,r)
case 2:return A.e(o.at(-1),r)}})
return A.h($async$d6,r)},
lG(a){var s,r=new A.l($.m,t.nI),q=new A.N(r,t.aP),p=v.G,o=new p.AbortController()
if(a!=null)a.J(new A.qe(this,q,o))
s={}
s.signal=o.signal
A.ar(p.navigator.locks.request(this.b,s,A.bB(new A.qg(q))),t.X).j6(new A.qf())
return r}}
A.qe.prototype={
$0(){var s=this.b
if((s.a.a&30)===0){s.ab(new A.bC("getWebLock("+this.a.b+")"))
this.c.abort("aborted in Dart")}},
$S:1}
A.qg.prototype={
$1(a){var s=new A.l($.m,t.D),r=new A.N(s,t.F),q=this.a
if((q.a.a&30)===0)q.T(new A.fi(r))
else r.L()
return A.wV(s)},
$S:34}
A.qf.prototype={
$1(a){return null},
$S:12}
A.fi.prototype={}
A.l8.prototype={
h9(a,b,c,d){return this.oJ(a,b,c,d)},
oJ(a,b,c,d){var s=0,r=A.i(t.u),q,p,o,n,m,l
var $async$h9=A.d(function(e,f){if(e===1)return A.e(f,r)
for(;;)switch(s){case 0:p=d==null?null:A.S(d)
o=a.oH(b,p!=null&&p.useMultipleCiphersVfs?"multipleciphers-"+c:c)
n=A.c3(!1,t.d)
m=A.u([],t.a6)
l=A.xz(o)
m.push(new A.aM(A.zi(),l,l.$ti.h("aM<D.T,K>")).O(n.gc4(n)))
q=new A.hY(o,n,m,A.T(t.eg,t.fK))
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$h9,r)},
cr(a,b){throw A.a(A.vI(null))}}
A.hY.prototype={
mk(a,b){if(!a.a){a.a=!0
b.b.a.aK(new A.l9(a),t.P)}},
n(){var s,r,q,p=this
p.kR()
for(s=p.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a6)(s),++q)s[q].u()
p.b.n()
s=p.d
if(s!=null)s.b.close()},
cr(a,b){return this.o3(a,b)},
o3(a,b){var s=0,r=A.i(t.X),q,p=this,o,n,m,l,k,j,i
var $async$cr=A.d(function(c,d){if(c===1)return A.e(d,r)
for(;;)switch(s){case 0:i=A.S(b.a)
case 3:switch(A.mV(B.af,i.rawKind).a){case 0:s=5
break
case 4:s=6
break
case 1:s=7
break
case 2:s=8
break
case 3:s=9
break
case 5:s=10
break
default:s=4
break}break
case 5:case 6:throw A.a(A.P("This is a response, not a request"))
case 7:q=p.a.gd8()
s=1
break
case 8:s=11
return A.b(b.c.$1$1(new A.la(p,i),t.P),$async$cr)
case 11:s=4
break
case 9:o=i.rawParameters
n=A.aY(o[0])
o=i.rawSql
m=p.e.cD(a,A.F3())
if(n){m.hj()
p.mk(m,a)
l=A.xO()
k=p.b
l.b=m.b=new A.aq(k,A.p(k).h("aq<1>")).O(new A.lb(l,a,o))}else m.hj()
s=4
break
case 10:o=i.name
if(p.d==null){j=p.d=new A.i3(new v.G.BroadcastChannel("sqlite3_async_updates/"+o))
o=p.c
k=A.xz(p.a)
o.push(new A.aM(A.zi(),k,k.$ti.h("aM<D.T,K>")).O(j.gkA()))
k=p.b
o.push(j.gp7().O(k.gc4(k)))}s=4
break
case 4:q={rawKind:"ok"}
s=1
break
case 1:return A.f(q,r)}})
return A.h($async$cr,r)},
gda(){return this.a}}
A.l9.prototype={
$1(a){this.a.hj()},
$S:9}
A.la.prototype={
$0(){var s,r,q,p,o,n,m,l=null,k=this.b
if(k.requireTransaction&&this.a.a.gd8())throw A.a(A.jj(A.AP(A.uK(k,"rawSql")),l,0,"Transaction rolled back by earlier statement. Cannot execute",l,l,l))
s=this.a.a.oO(k.rawSql)
try{k=k.parameters
k=J.Z(t.ip.b(k)?k:new A.ag(k,A.a5(k).h("ag<1,v>")))
while(k.m()){r=k.gp()
q=s
p=r
o=p.parameters
p=p.parameterTypes
p.toString
n=new Uint8Array(p,0)
if(q.r||q.b.r)A.r(A.z(u.f))
if(!q.f){m=q.a
m.c.d.sqlite3_reset(m.b)
q.f=!0}q.hI(new A.f7(new A.cj(o,p,n).gj2()))
q.i1()}}finally{s.n()}},
$S:1}
A.lb.prototype={
$1(a){var s=this.a.dW(),r=a.a
r=A.ap(r,A.p(r).c)
s.aJ(this.b.aX(A.vm(B.F,this.c,r)))},
$S:31}
A.el.prototype={
hj(){var s=this.b
if(s!=null){this.b=null
s.u()}}}
A.jn.prototype={
gdK(){return A.al(this.c)}}
A.pc.prototype={
gh4(){var s=this
if(s.c!==s.e)s.d=null
return s.d},
eO(a){var s,r=this,q=r.d=J.A_(a,r.b,r.c)
r.e=r.c
s=q!=null
if(s)r.e=r.c=q.gC()
return s},
jj(a,b){var s
if(this.eO(a))return
if(b==null)if(a instanceof A.fm)b="/"+a.a+"/"
else{s=J.be(a)
s=A.hM(s,"\\","\\\\")
b='"'+A.hM(s,'"','\\"')+'"'}this.i2(b)},
de(a){return this.jj(a,null)},
nQ(){if(this.c===this.b.length)return
this.i2("no more input")},
nM(a,b,c){var s,r,q,p,o,n=this.b
if(c<0)A.r(A.az("position must be greater than or equal to 0."))
else if(c>n.length)A.r(A.az("position must be less than or equal to the string length."))
s=c+b>n.length
if(s)A.r(A.az("position plus length must not go beyond the end of the string."))
s=this.a
r=A.u([0],t.t)
q=n.length
p=new A.oB(s,r,new Uint32Array(q))
p.l_(new A.br(n),s)
o=c+b
if(o>q)A.r(A.az("End "+o+u.D+p.gk(0)+"."))
else if(c<0)A.r(A.az("Start may not be negative, was "+c+"."))
throw A.a(new A.jn(n,a,new A.er(p,c,o)))},
i2(a){this.nM("expected "+a+".",0,this.c)}}
A.ea.prototype={
gk(a){return this.b},
i(a,b){if(b>=this.b)throw A.a(A.wX(b,this))
return this.a[b]},
l(a,b,c){var s
if(b>=this.b)throw A.a(A.wX(b,this))
s=this.a
s.$flags&2&&A.C(s)
s[b]=c},
sk(a,b){var s,r,q,p,o=this,n=o.b
if(b<n)for(s=o.a,r=s.$flags|0,q=b;q<n;++q){r&2&&A.C(s)
s[q]=0}else{n=o.a.length
if(b>n){if(n===0)p=new Uint8Array(b)
else p=o.f6(b)
B.f.af(p,0,o.b,o.a)
o.a=p}}o.b=b},
mK(a){var s,r=this,q=r.b
if(q===r.a.length)r.ib(q)
q=r.a
s=r.b++
q.$flags&2&&A.C(q)
q[s]=a},
q(a,b){var s,r=this,q=r.b
if(q===r.a.length)r.ib(q)
q=r.a
s=r.b++
q.$flags&2&&A.C(q)
q[s]=b},
hE(a,b,c){var s,r,q
if(t.j.b(a))c=c==null?J.aN(a):c
if(c!=null){this.lP(this.b,a,b,c)
return}for(s=J.Z(a),r=0;s.m();){q=s.gp()
if(r>=b)this.mK(q);++r}if(r<b)throw A.a(A.z("Too few elements"))},
lP(a,b,c,d){var s,r,q,p,o=this
if(t.j.b(b)){s=J.ab(b)
if(c>s.gk(b)||d>s.gk(b))throw A.a(A.z("Too few elements"))}r=d-c
q=o.b+r
o.lA(q)
s=o.a
p=a+r
B.f.X(s,p,o.b+r,s,a)
B.f.X(o.a,a,p,b,c)
o.b=q},
lA(a){var s,r=this
if(a<=r.a.length)return
s=r.f6(a)
B.f.af(s,0,r.b,r.a)
r.a=s},
f6(a){var s=this.a.length*2
if(a!=null&&s<a)s=a
else if(s<8)s=8
return new Uint8Array(s)},
ib(a){var s=this.f6(null)
B.f.af(s,0,a,this.a)
this.a=s},
X(a,b,c,d,e){var s=this.b
if(c>s)throw A.a(A.ac(c,0,s,null,null))
s=this.a
if(d instanceof A.bg)B.f.X(s,b,c,d.a,e)
else B.f.X(s,b,c,d,e)},
af(a,b,c,d){return this.X(0,b,c,d,0)}}
A.k1.prototype={}
A.bg.prototype={}
A.vn.prototype={}
A.ep.prototype={
gaw(){return!0},
B(a,b,c,d){return A.aD(this.a,this.b,a,!1,this.$ti.c)},
O(a){return this.B(a,null,null,null)},
az(a,b,c){return this.B(a,null,b,c)},
bq(a,b,c){return this.B(a,b,c,null)}}
A.eq.prototype={
u(){var s=this,r=A.n5(null,t.H)
if(s.b==null)return r
s.fC()
s.d=s.b=null
return r},
bt(a){var s,r=this
if(r.b==null)throw A.a(A.z("Subscription has been canceled."))
r.fC()
s=A.yQ(new A.rv(a),t.m)
s=s==null?null:A.bB(s)
r.d=s
r.fA()},
ds(a){},
aJ(a){var s=this
if(s.b==null)return;++s.a
s.fC()
if(a!=null)a.J(s.gbN())},
aj(){return this.aJ(null)},
am(){var s=this
if(s.b==null||s.a<=0)return;--s.a
s.fA()},
fA(){var s=this,r=s.d
if(r!=null&&s.a<=0)s.b.addEventListener(s.c,r,!1)},
fC(){var s=this.d
if(s!=null)this.b.removeEventListener(this.c,s,!1)},
$iae:1}
A.ru.prototype={
$1(a){return this.a.$1(a)},
$S:2}
A.rv.prototype={
$1(a){return this.a.$1(a)},
$S:2};(function aliases(){var s=J.cn.prototype
s.kN=s.j
s=A.b4.prototype
s.kJ=s.jx
s.kK=s.jy
s.kM=s.jA
s.kL=s.jz
s=A.c9.prototype
s.kS=s.ak
s=A.aw.prototype
s.bT=s.N
s.eR=s.a9
s.hA=s.Z
s=A.cb.prototype
s.kT=s.hS
s.kU=s.i8
s.kV=s.iG
s=A.y.prototype
s.hz=s.X
s=A.ah.prototype
s.hy=s.bj
s=A.hw.prototype
s.kW=s.n
s=A.i0.prototype
s.hx=s.nT
s=A.e6.prototype
s.kP=s.a_
s.kO=s.D
s=A.cy.prototype
s.kR=s.n
s=A.K.prototype
s.kQ=s.fM})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._instance_0u,q=hunkHelpers._instance_1u,p=hunkHelpers.installInstanceTearOff,o=hunkHelpers._static_1,n=hunkHelpers._static_0,m=hunkHelpers.installStaticTearOff,l=hunkHelpers._instance_1i,k=hunkHelpers._instance_2u
s(J,"De","AM",38)
var j
r(j=A.dG.prototype,"ge9","u",20)
q(j,"glc","ld",5)
p(j,"geu",0,0,null,["$1","$0"],["aJ","aj"],33,0,0)
r(j,"gbN","am",0)
o(A,"DV","BN",14)
o(A,"DW","BO",14)
o(A,"DX","BP",14)
o(A,"DY","Du",17)
n(A,"yS","DM",0)
o(A,"DZ","Dv",13)
s(A,"E_","Dx",6)
n(A,"uz","Dw",0)
m(A,"E3",5,null,["$5"],["DF"],165,0)
m(A,"E8",4,null,["$1$4","$4"],["uj",function(a,b,c,d){return A.uj(a,b,c,d,t.z)}],166,0)
m(A,"Ea",5,null,["$2$5","$5"],["uk",function(a,b,c,d,e){var i=t.z
return A.uk(a,b,c,d,e,i,i)}],167,0)
m(A,"E9",6,null,["$3$6"],["wd"],168,0)
m(A,"E6",4,null,["$1$4","$4"],["yH",function(a,b,c,d){return A.yH(a,b,c,d,t.z)}],169,0)
m(A,"E7",4,null,["$2$4","$4"],["yI",function(a,b,c,d){var i=t.z
return A.yI(a,b,c,d,i,i)}],170,0)
m(A,"E5",4,null,["$3$4","$4"],["yG",function(a,b,c,d){var i=t.z
return A.yG(a,b,c,d,i,i,i)}],171,0)
m(A,"E1",5,null,["$5"],["DE"],172,0)
m(A,"Eb",4,null,["$4"],["ul"],173,0)
m(A,"E0",5,null,["$5"],["DD"],174,0)
m(A,"G2",5,null,["$5"],["DC"],175,0)
m(A,"E4",4,null,["$4"],["DG"],176,0)
m(A,"E2",5,null,["$5"],["yF"],177,0)
r(j=A.dk.prototype,"gcX","b2",0)
r(j,"gcY","b3",0)
l(j=A.c9.prototype,"gc4","q",5)
r(j,"gaG","n",3)
q(j,"geU","N",5)
k(j,"gdN","a9",6)
r(j,"gf_","Z",0)
p(A.dl.prototype,"gn9",0,1,null,["$2","$1"],["b7","ab"],30,0,0)
k(A.l.prototype,"gf4","lo",6)
l(j=A.cB.prototype,"gc4","q",5)
p(j,"gfG",0,1,null,["$2","$1"],["ag","mZ"],30,0,0)
r(j,"gaG","n",20)
q(j,"geU","N",5)
k(j,"gdN","a9",6)
r(j,"gf_","Z",0)
r(j=A.cA.prototype,"gcX","b2",0)
r(j,"gcY","b3",0)
p(j=A.aw.prototype,"geu",0,0,null,["$1","$0"],["aJ","aj"],32,0,0)
r(j,"gbN","am",0)
r(j,"ge9","u",20)
r(j,"gcX","b2",0)
r(j,"gcY","b3",0)
p(j=A.eo.prototype,"geu",0,0,null,["$1","$0"],["aJ","aj"],32,0,0)
r(j,"gbN","am",0)
r(j,"ge9","u",20)
r(j,"gim","m9",0)
q(j=A.bP.prototype,"gm1","m2",5)
k(j,"gm5","m6",6)
r(j,"gm3","m4",0)
r(j=A.es.prototype,"gcX","b2",0)
r(j,"gcY","b3",0)
q(j,"gfe","ff",5)
k(j,"gfi","fj",160)
r(j,"gfg","fh",0)
r(j=A.eA.prototype,"gcX","b2",0)
r(j,"gcY","b3",0)
q(j,"gfe","ff",5)
k(j,"gfi","fj",6)
r(j,"gfg","fh",0)
s(A,"wg","D1",24)
o(A,"wh","D2",29)
s(A,"Ef","AT",38)
o(A,"Ei","D3",50)
o(A,"Eh","Cf",178)
l(j=A.jO.prototype,"gc4","q",5)
r(j,"gaG","n",0)
o(A,"yV","Ex",29)
s(A,"yU","Ew",24)
o(A,"Ej","BF",11)
m(A,"EM",2,null,["$1$2","$2"],["z2",function(a,b){return A.z2(a,b,t.q)}],179,0)
r(j=A.fI.prototype,"gm7","m8",0)
r(j,"gmG","mH",0)
r(j,"gmI","mJ",0)
r(j,"gmF","iK",36)
k(j=A.f8.prototype,"gnL","bG",24)
q(j,"gof","h_",29)
q(j,"gom","on",17)
o(A,"Ed","A8",11)
o(A,"ED","AH",180)
o(A,"EX","C_",181)
o(A,"EY","Bb",182)
r(A.kj.prototype,"gnR","jk",0)
r(A.ci.prototype,"goC","h6",0)
r(A.jC.prototype,"gaG","n",3)
q(A.j4.prototype,"gp9","pa",18)
q(j=A.id.prototype,"goA","oB",8)
k(j,"gov","ow",101)
p(j,"gpE",0,5,null,["$5"],["pF"],102,0,0)
p(j,"gpr",0,3,null,["$3"],["ps"],103,0,0)
p(j,"gpj",0,4,null,["$4"],["pk"],44,0,0)
p(j,"gpA",0,4,null,["$4"],["pB"],44,0,0)
p(j,"gpG",0,3,null,["$3"],["pH"],105,0,0)
k(j,"gpL","pM",49)
k(j,"gpp","pq",49)
q(j,"gpn","po",27)
p(j,"gpI",0,4,null,["$4"],["pJ"],41,0,0)
p(j,"gpT",0,4,null,["$4"],["pU"],41,0,0)
k(j,"gpP","pQ",109)
k(j,"gpN","pO",10)
k(j,"gpw","px",10)
k(j,"gpy","pz",10)
k(j,"gpC","pD",10)
k(j,"gpR","pS",10)
k(j,"gpl","pm",10)
q(j,"geJ","pt",27)
p(j,"gpu",0,3,null,["$3"],["pv"],111,0,0)
q(j,"geL","pK",27)
q(j,"gnt","nu",14)
q(j,"gno","np",112)
p(j,"gnr",0,5,null,["$5"],["ns"],113,0,0)
p(j,"gnz",0,4,null,["$4"],["nA"],28,0,0)
p(j,"gnD",0,4,null,["$4"],["nE"],28,0,0)
p(j,"gnB",0,4,null,["$4"],["nC"],28,0,0)
k(j,"gnF","nG",39)
k(j,"gnx","ny",39)
p(j,"gnv",0,5,null,["$5"],["nw"],116,0,0)
k(j,"gnm","nn",117)
k(j,"gnk","nl",118)
p(j,"gni",0,3,null,["$3"],["nj"],119,0,0)
r(j=A.cl.prototype,"gaG","n",3)
r(j,"gnV","jn",3)
r(A.e4.prototype,"gaG","n",0)
q(A.jD.prototype,"gjs","fU",2)
r(A.ie.prototype,"glL","lM",0)
q(A.cj.prototype,"gj2","j3",138)
q(A.ej.prototype,"gjs","fU",2)
o(A,"zi","By",183)
r(A.dv.prototype,"gn0","n1",0)
q(A.i3.prototype,"gkA","ao",31)
q(A.ju.prototype,"gob","fV",163)
n(A,"F3","C1",122)
r(j=A.eq.prototype,"ge9","u",3)
p(j,"geu",0,0,null,["$1","$0"],["aJ","aj"],33,0,0)
r(j,"gbN","am",0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.k,null)
q(A.k,[A.vv,J.ix,A.fB,J.dF,A.D,A.dG,A.n,A.i7,A.cT,A.G,A.W,A.y,A.ox,A.at,A.cp,A.ef,A.im,A.jo,A.j9,A.ii,A.jB,A.iS,A.ff,A.jr,A.fL,A.hn,A.f2,A.et,A.cu,A.pB,A.iU,A.fb,A.hu,A.nM,A.d0,A.b6,A.iI,A.fm,A.ex,A.jG,A.fK,A.tv,A.jP,A.kB,A.bt,A.jY,A.tC,A.kx,A.h0,A.jI,A.he,A.kv,A.a2,A.aw,A.c9,A.bN,A.dl,A.bj,A.l,A.jH,A.jk,A.cB,A.kw,A.jJ,A.h_,A.jT,A.rq,A.ey,A.eo,A.bP,A.ha,A.tX,A.tZ,A.tY,A.tV,A.tW,A.tU,A.tR,A.kG,A.tQ,A.tP,A.tT,A.tS,A.kF,A.kH,A.kE,A.eH,A.fY,A.jZ,A.t8,A.ev,A.k5,A.aH,A.kA,A.fs,A.k6,A.jm,A.ia,A.ah,A.lx,A.qO,A.i9,A.dm,A.t3,A.tw,A.kD,A.cF,A.aA,A.jW,A.bT,A.b1,A.rr,A.iV,A.fG,A.jV,A.aU,A.iw,A.M,A.F,A.ku,A.a0,A.hD,A.pN,A.bk,A.io,A.vN,A.iT,A.rY,A.rZ,A.ij,A.fV,A.fI,A.eB,A.U,A.f8,A.eE,A.ew,A.iK,A.iR,A.js,A.l4,A.bR,A.i_,A.i0,A.lj,A.ft,A.co,A.dU,A.dV,A.m0,A.pd,A.o2,A.iX,A.hQ,A.cr,A.f6,A.f5,A.e_,A.dc,A.cZ,A.K,A.dH,A.lI,A.ca,A.fr,A.dN,A.lH,A.fS,A.m4,A.mQ,A.fd,A.dI,A.f9,A.f0,A.fh,A.fQ,A.nF,A.fM,A.lG,A.aL,A.dL,A.eh,A.oY,A.qt,A.cs,A.fU,A.fP,A.fg,A.f1,A.kj,A.vV,A.pn,A.ci,A.e9,A.fZ,A.hs,A.h7,A.h4,A.jC,A.oh,A.j4,A.i8,A.rs,A.mx,A.o6,A.oB,A.jc,A.e6,A.nb,A.aP,A.by,A.bv,A.jf,A.ba,A.da,A.my,A.cC,A.oD,A.cU,A.aC,A.i1,A.m6,A.ko,A.kk,A.nA,A.f7,A.c6,A.fF,A.q1,A.pX,A.q3,A.q2,A.di,A.cx,A.id,A.dn,A.pY,A.lc,A.hd,A.rw,A.k7,A.k0,A.ta,A.pS,A.dJ,A.ot,A.f_,A.jQ,A.j3,A.mw,A.ic,A.cy,A.ip,A.na,A.bV,A.ie,A.dW,A.cV,A.o7,A.d6,A.rp,A.tO,A.rn,A.hv,A.ek,A.ig,A.qp,A.tj,A.jg,A.bC,A.jt,A.fC,A.dv,A.i3,A.ju,A.qc,A.fi,A.el,A.pc,A.vn,A.eq])
q(J.ix,[J.iz,J.dR,J.ai,J.aQ,J.dT,J.dS,J.cm])
q(J.ai,[J.cn,J.w,A.dX,A.fw])
q(J.cn,[J.iY,J.de,J.b2])
r(J.iy,A.fB)
r(J.nI,J.w)
q(J.dS,[J.fl,J.iA])
q(A.D,[A.cS,A.eC,A.fJ,A.dp,A.bz,A.bb,A.c8,A.eW,A.ep])
q(A.n,[A.cz,A.x,A.bY,A.c7,A.fc,A.dd,A.c1,A.fX,A.fz,A.hf,A.jF,A.kt,A.eD,A.d1])
q(A.cz,[A.cQ,A.hG])
r(A.h9,A.cQ)
r(A.h3,A.hG)
q(A.cT,[A.lM,A.lE,A.lL,A.nB,A.pp,A.uN,A.uP,A.qF,A.qE,A.u1,A.u0,A.tx,A.tz,A.ty,A.n8,A.n0,A.n4,A.rz,A.ry,A.rK,A.rN,A.oO,A.oV,A.oT,A.oW,A.oR,A.rm,A.th,A.rj,A.t7,A.nR,A.m3,A.mU,A.qT,A.n1,A.uR,A.v7,A.v8,A.oL,A.oK,A.lA,A.lC,A.li,A.lo,A.u3,A.ly,A.nX,A.uF,A.m1,A.m2,A.ux,A.v5,A.v4,A.ue,A.lw,A.lu,A.lv,A.lq,A.lJ,A.m5,A.pm,A.uY,A.uW,A.uA,A.ve,A.pQ,A.p1,A.p9,A.p8,A.p2,A.p3,A.p4,A.p7,A.p6,A.p_,A.qu,A.qA,A.qz,A.qy,A.qv,A.qw,A.lY,A.lZ,A.pg,A.pi,A.pj,A.pk,A.pM,A.qo,A.qn,A.uT,A.uU,A.uS,A.nd,A.nc,A.ne,A.ng,A.ni,A.nf,A.nw,A.oH,A.mG,A.ts,A.v3,A.v9,A.va,A.l7,A.rh,A.ri,A.lP,A.lQ,A.lU,A.lV,A.lW,A.mX,A.lf,A.ld,A.rS,A.rV,A.rW,A.nz,A.nx,A.rR,A.oA,A.pT,A.pU,A.pV,A.pW,A.oc,A.od,A.ob,A.oa,A.o9,A.om,A.oi,A.op,A.oq,A.oj,A.qa,A.mJ,A.nZ,A.mW,A.ou,A.ov,A.uC,A.lN,A.lO,A.lR,A.lS,A.lT,A.ua,A.r3,A.r1,A.r7,A.ra,A.r_,A.tk,A.tl,A.tn,A.oG,A.oE,A.oF,A.pK,A.pJ,A.ur,A.uu,A.px,A.pr,A.ps,A.pt,A.py,A.pw,A.q6,A.q9,A.q8,A.q7,A.q5,A.lm,A.lk,A.ll,A.qU,A.pG,A.qg,A.qf,A.l9,A.lb,A.ru,A.rv])
q(A.lM,[A.qY,A.lF,A.m_,A.nJ,A.uO,A.u2,A.uy,A.n9,A.n_,A.rA,A.rL,A.rO,A.qC,A.u4,A.rP,A.nN,A.nT,A.mT,A.t4,A.qS,A.pO,A.n3,A.n2,A.lz,A.lB,A.lD,A.lh,A.nY,A.mR,A.vf,A.pb,A.qx,A.vB,A.nh,A.rX,A.qb,A.re,A.qs,A.pL,A.uw,A.ub])
r(A.ag,A.h3)
q(A.G,[A.cR,A.b4,A.cb,A.k2])
q(A.W,[A.d_,A.c4,A.iB,A.jq,A.j6,A.jU,A.dZ,A.fo,A.hW,A.a3,A.fR,A.jp,A.aX,A.ib,A.iJ])
q(A.y,[A.eb,A.ed,A.cj,A.ea])
r(A.br,A.eb)
q(A.lL,[A.v2,A.qG,A.qH,A.tB,A.tA,A.u_,A.qJ,A.qK,A.qM,A.qN,A.qL,A.qI,A.n6,A.rB,A.rG,A.rF,A.rD,A.rC,A.rJ,A.rI,A.rH,A.rM,A.oP,A.oU,A.oS,A.oX,A.oQ,A.tr,A.tq,A.qB,A.qX,A.qW,A.tb,A.t9,A.u5,A.u6,A.rl,A.rk,A.tg,A.tf,A.ui,A.tL,A.tK,A.uf,A.ud,A.oM,A.oN,A.oJ,A.ln,A.ug,A.uh,A.nW,A.nQ,A.l2,A.l3,A.uZ,A.uX,A.v_,A.v0,A.v1,A.vd,A.pR,A.p0,A.oZ,A.pa,A.p5,A.u9,A.or,A.td,A.po,A.lX,A.pl,A.ph,A.qj,A.qk,A.ql,A.qm,A.nv,A.nj,A.nq,A.nr,A.ns,A.nt,A.no,A.np,A.nk,A.nl,A.nm,A.nn,A.nu,A.rQ,A.mH,A.mI,A.mE,A.mD,A.mF,A.mA,A.mz,A.mB,A.mC,A.tt,A.tu,A.vb,A.mh,A.md,A.mm,A.mo,A.mr,A.mg,A.mf,A.mp,A.mv,A.mt,A.ms,A.ml,A.mk,A.mn,A.mu,A.me,A.mi,A.mj,A.mq,A.mb,A.mc,A.ma,A.m9,A.m8,A.l5,A.l6,A.pZ,A.le,A.rT,A.rU,A.rx,A.ny,A.oe,A.on,A.oo,A.ok,A.ol,A.mK,A.mL,A.o0,A.o_,A.rc,A.rg,A.rd,A.rf,A.r0,A.r6,A.r9,A.r2,A.r8,A.rb,A.r4,A.r5,A.mO,A.mN,A.mM,A.qq,A.qr,A.to,A.tm,A.tp,A.us,A.ut,A.un,A.um,A.uv,A.uo,A.up,A.uq,A.pz,A.pu,A.pv,A.pq,A.q4,A.tI,A.tH,A.tG,A.tF,A.pH,A.pI,A.qe,A.la])
q(A.x,[A.X,A.cX,A.b5,A.bX,A.aG,A.hc])
q(A.X,[A.db,A.a8,A.d8,A.fq,A.k3])
r(A.bU,A.bY)
r(A.fa,A.dd)
r(A.dM,A.c1)
q(A.hn,[A.k8,A.k9,A.ka,A.kb])
r(A.ho,A.k8)
q(A.k9,[A.Q,A.hp,A.hq,A.kc,A.ez,A.kd,A.ke])
q(A.ka,[A.hr,A.kf,A.kg,A.kh])
r(A.ki,A.kb)
r(A.b0,A.f2)
q(A.cu,[A.f3,A.ht])
r(A.f4,A.f3)
r(A.fk,A.nB)
r(A.fA,A.c4)
q(A.pp,[A.oI,A.eX])
q(A.b4,[A.fn,A.hg])
r(A.bF,A.dX)
q(A.fw,[A.fv,A.dY])
q(A.dY,[A.hi,A.hk])
r(A.hj,A.hi)
r(A.cq,A.hj)
r(A.hl,A.hk)
r(A.b8,A.hl)
q(A.cq,[A.iL,A.iM])
q(A.b8,[A.iN,A.iO,A.iP,A.iQ,A.fx,A.fy,A.d3])
r(A.hx,A.jU)
r(A.a4,A.eC)
r(A.aq,A.a4)
q(A.aw,[A.cA,A.es,A.eA])
r(A.dk,A.cA)
q(A.c9,[A.du,A.h1])
q(A.dl,[A.aa,A.N])
q(A.cB,[A.bL,A.cD])
r(A.ks,A.h_)
q(A.jT,[A.bx,A.en])
r(A.hh,A.bL)
q(A.bb,[A.ce,A.aM])
q(A.jk,[A.kr,A.nL])
q(A.kE,[A.jR,A.kn])
q(A.cb,[A.dr,A.h5])
r(A.cc,A.ht)
r(A.hC,A.fs)
r(A.df,A.hC)
q(A.jm,[A.hw,A.tD,A.t6,A.dt])
r(A.t0,A.hw)
q(A.ia,[A.cY,A.lg,A.nK])
q(A.cY,[A.hT,A.iF,A.jx])
q(A.ah,[A.kz,A.ky,A.hZ,A.iE,A.iD,A.jz,A.jy])
q(A.kz,[A.hV,A.iH])
q(A.ky,[A.hU,A.iG])
q(A.lx,[A.rt,A.ti,A.qP,A.jN,A.jO,A.k4,A.kC])
r(A.qV,A.qO)
r(A.qD,A.qP)
r(A.iC,A.fo)
r(A.t1,A.i9)
r(A.t2,A.t3)
r(A.t5,A.k4)
r(A.eu,A.t6)
r(A.kI,A.kD)
r(A.tM,A.kI)
q(A.a3,[A.e1,A.fj])
r(A.jS,A.hD)
r(A.d9,A.eE)
r(A.ct,A.bR)
q(A.i_,[A.i4,A.e2])
r(A.cP,A.fJ)
r(A.os,A.i0)
r(A.jE,A.os)
r(A.hR,A.jE)
q(A.lj,[A.e3,A.cw])
r(A.jl,A.cw)
r(A.eZ,A.U)
r(A.nG,A.pd)
q(A.nG,[A.o3,A.pP,A.qi])
q(A.rr,[A.fT,A.pe,A.dK,A.af,A.e7,A.o1,A.dO,A.fu,A.ck,A.bw,A.fe,A.cv,A.bS])
r(A.bf,A.K)
q(A.ca,[A.hm,A.ei,A.h8])
q(A.lG,[A.fp,A.d7])
q(A.mx,[A.l8,A.ro])
r(A.o4,A.l8)
r(A.ir,A.jc)
q(A.e6,[A.er,A.je])
r(A.e5,A.jf)
r(A.c2,A.je)
r(A.e8,A.cU)
r(A.i2,A.aC)
q(A.i2,[A.it,A.cl,A.e4])
q(A.i1,[A.k_,A.kq])
r(A.kl,A.m6)
r(A.km,A.kl)
r(A.bG,A.km)
r(A.kp,A.ko)
r(A.aW,A.kp)
q(A.aH,[A.dj,A.aE])
r(A.ec,A.oD)
q(A.aE,[A.hb,A.h6,A.em,A.eG])
r(A.o8,A.ot)
q(A.o8,[A.jD,A.ej])
r(A.m7,A.ic)
r(A.bq,A.d6)
r(A.jh,A.jg)
r(A.ji,A.jh)
r(A.fD,A.fC)
r(A.jA,A.ji)
r(A.cd,A.jt)
r(A.hY,A.cy)
r(A.jn,A.e5)
r(A.k1,A.ea)
r(A.bg,A.k1)
s(A.eb,A.jr)
s(A.hG,A.y)
s(A.hi,A.y)
s(A.hj,A.ff)
s(A.hk,A.y)
s(A.hl,A.ff)
s(A.bL,A.jJ)
s(A.cD,A.kw)
s(A.hC,A.kA)
s(A.kI,A.jm)
s(A.jE,A.l4)
s(A.kl,A.y)
s(A.km,A.iR)
s(A.ko,A.js)
s(A.kp,A.G)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{c:"int",Y:"double",bQ:"num",j:"String",H:"bool",F:"Null",t:"List",k:"Object",a_:"Map",v:"JSObject"},mangledNames:{},types:["~()","F()","~(v)","o<~>()","c()","~(k?)","~(k,ad)","F(k,ad)","~(c)","F(~)","c(aO,c)","j(j)","F(@)","~(@)","~(~())","F(v)","o<~>(hd)","H(k?)","o<~>(o<~>)","v()","o<@>()","o<bG>()","~(~)","H(aP)","H(k?,k?)","H(j)","o<cr?>(o<~>)","c(aO)","~(j2,c,c,c)","c(k?)","~(k[ad?])","~(K)","~([o<~>?])","~([o<@>?])","v(k)","v(H)","o<~>?()","o<ae<~>>()","c(@,@)","~(j2,c)","~(ba)","c(aO,c,c,aQ)","H()","o<j>(aK)","c(aC,c,c,c)","~(j,j)","j(d2)","j(k?)","~(dv)","c(aC,c)","@(@)","o<F>()","~(dU)","@()","~(k?,k?)","o<cy>()","H(ca)","dL(k?)","M<j,+atLast,priority,sinceLast,targetCount(c,c,c,c)>(j,k?)","j(+(j,k?))","o<~>(ae<~>)","o<+immediateRestart(H)>()","o<H>(aK)","o<j>()","o<j>(o<~>)","o<c?>(aB)","o<e3>(o<~>)","o<dQ?>()","o<dQ?>(aK)","a_<j,@>(+name,parameters(j,j))","o<+immediateRestart(H)>(o<~>)","o<~>(aK)","D<aS>?(cw)","F(cr?)","e9()","o<+(k,F)>(af,k,o<~>)","e2()","H(bf)","bf(K)","~(aL)","~(j)","+name,parameters(j,j)(k?)","o<~>(v)","o<+(F,F)>()","o<+(v,F)>()","o<+(bF?,w<k?>?)>()","+(k?,w<k?>?)/()","@(@,j)","j?()","c(by)","j(j?)","k(by)","0&(j,c?)","c(aP,aP)","t<by>(M<k,t<aP>>)","F(@,ad)","c2()","dV()","~(c,j,c)","~(c,@)","~(B,a9,B,~())","~(aQ,c)","aO?(aC,c,c,c,c)","c(aC,c,c)","ft()","c(aC?,c,c)","~(t<c>)","~(bZ<t<c>>)","F(j,j[k?])","c(aO,aQ)","l<@>?()","c(aO,c,c)","c(c())","~(~(c,j,c),c,c,c,aQ)","c(j)","H(j,j)","c(j2,c,c,c,c)","c(c(c),c)","c(vD,c)","c(vD,c,c)","@(j)","v(w<k?>)","el()","v(v?)","~(cO)","o<~>(c,bh)","o<~>(c)","bh()","o<v>(j)","~(wJ)","F(bV)","o<F>(v)","k?(k?)","k?(~)","F(k?,ad)","j?(k?)","F(b2,b2)","j?(j?)","~(cU)","v(v)","o<0^>(0^())<k?>","o<v>()","v?()","c(c)","o<ae<ba>>()","c(c,c)","j(a0)","H(ek)","a0(a0,j)","o<cV>()","0&(k?,ad)","o<bG>(aB)","o<aW?>(aB)","K(K,K)","D<K>(D<K>)","H(K)","dm<@,@>(aj<@>)","~(bZ<bu<j>>)","~(@,@)","0&(bq,ad)","~(@,ad)","K?(v)","H(K?)","o<k?>(k?)","F(~())","~(B?,a9?,B,k,ad)","0^(B?,a9?,B,0^())<k?>","0^(B?,a9?,B,0^(1^),1^)<k?,k?>","0^(B?,a9?,B,0^(1^,2^),1^,2^)<k?,k?,k?>","0^()(B,a9,B,0^())<k?>","0^(1^)(B,a9,B,0^(1^))<k?,k?>","0^(1^,2^)(B,a9,B,0^(1^,2^))<k?,k?,k?>","a2?(B,a9,B,k,ad?)","~(B?,a9?,B,~())","fO(B,a9,B,b1,~())","fO(B,a9,B,b1,~(fO))","~(B,a9,B,j)","B(B?,a9?,B,fY?,a_<k?,k?>?)","eu(aj<j>)","0^(0^,0^)<bQ>","as(a_<j,k?>)","eh(aj<bh>)","cs(k)","K(bu<j>)","k(aP)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"1;immediateRestart":a=>b=>b instanceof A.ho&&a.b(b.a),"2;":(a,b)=>c=>c instanceof A.Q&&a.b(c.a)&&b.b(c.b),"2;basicSupport,supportsReadWriteUnsafe":(a,b)=>c=>c instanceof A.hp&&a.b(c.a)&&b.b(c.b),"2;controller,sync":(a,b)=>c=>c instanceof A.hq&&a.b(c.a)&&b.b(c.b),"2;downloaded,total":(a,b)=>c=>c instanceof A.kc&&a.b(c.a)&&b.b(c.b),"2;file,outFlags":(a,b)=>c=>c instanceof A.ez&&a.b(c.a)&&b.b(c.b),"2;name,parameters":(a,b)=>c=>c instanceof A.kd&&a.b(c.a)&&b.b(c.b),"2;result,resultCode":(a,b)=>c=>c instanceof A.ke&&a.b(c.a)&&b.b(c.b),"3;":(a,b,c)=>d=>d instanceof A.hr&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"3;autocommit,lastInsertRowid,result":(a,b,c)=>d=>d instanceof A.kf&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"3;connectName,connectPort,lockName":(a,b,c)=>d=>d instanceof A.kg&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"3;hasSynced,lastSyncedAt,priority":(a,b,c)=>d=>d instanceof A.kh&&a.b(d.a)&&b.b(d.b)&&c.b(d.c),"4;atLast,priority,sinceLast,targetCount":a=>b=>b instanceof A.ki&&A.EN(a,b.a)}}
A.CB(v.typeUniverse,JSON.parse('{"b2":"cn","iY":"cn","de":"cn","Fh":"dX","w":{"t":["1"],"ai":[],"x":["1"],"v":[],"n":["1"],"aF":["1"]},"iz":{"H":[],"a1":[]},"dR":{"F":[],"a1":[]},"ai":{"v":[]},"cn":{"ai":[],"v":[]},"iy":{"fB":[]},"nI":{"w":["1"],"t":["1"],"ai":[],"x":["1"],"v":[],"n":["1"],"aF":["1"]},"dS":{"Y":[],"a7":["bQ"]},"fl":{"Y":[],"c":[],"a7":["bQ"],"a1":[]},"iA":{"Y":[],"a7":["bQ"],"a1":[]},"cm":{"j":[],"a7":["j"],"aF":["@"],"a1":[]},"cS":{"D":["2"],"D.T":"2"},"dG":{"ae":["2"]},"cz":{"n":["2"]},"cQ":{"cz":["1","2"],"n":["2"],"n.E":"2"},"h9":{"cQ":["1","2"],"cz":["1","2"],"x":["2"],"n":["2"],"n.E":"2"},"h3":{"y":["2"],"t":["2"],"cz":["1","2"],"x":["2"],"n":["2"]},"ag":{"h3":["1","2"],"y":["2"],"t":["2"],"cz":["1","2"],"x":["2"],"n":["2"],"y.E":"2","n.E":"2"},"cR":{"G":["3","4"],"a_":["3","4"],"G.V":"4","G.K":"3"},"d_":{"W":[]},"br":{"y":["c"],"t":["c"],"x":["c"],"n":["c"],"y.E":"c"},"x":{"n":["1"]},"X":{"x":["1"],"n":["1"]},"db":{"X":["1"],"x":["1"],"n":["1"],"X.E":"1","n.E":"1"},"bY":{"n":["2"],"n.E":"2"},"bU":{"bY":["1","2"],"x":["2"],"n":["2"],"n.E":"2"},"a8":{"X":["2"],"x":["2"],"n":["2"],"X.E":"2","n.E":"2"},"c7":{"n":["1"],"n.E":"1"},"fc":{"n":["2"],"n.E":"2"},"dd":{"n":["1"],"n.E":"1"},"fa":{"dd":["1"],"x":["1"],"n":["1"],"n.E":"1"},"c1":{"n":["1"],"n.E":"1"},"dM":{"c1":["1"],"x":["1"],"n":["1"],"n.E":"1"},"cX":{"x":["1"],"n":["1"],"n.E":"1"},"fX":{"n":["1"],"n.E":"1"},"fz":{"n":["1"],"n.E":"1"},"eb":{"y":["1"],"t":["1"],"x":["1"],"n":["1"]},"d8":{"X":["1"],"x":["1"],"n":["1"],"X.E":"1","n.E":"1"},"f2":{"a_":["1","2"]},"b0":{"f2":["1","2"],"a_":["1","2"]},"hf":{"n":["1"],"n.E":"1"},"f3":{"cu":["1"],"bu":["1"],"x":["1"],"n":["1"]},"f4":{"cu":["1"],"bu":["1"],"x":["1"],"n":["1"]},"fA":{"c4":[],"W":[]},"iB":{"W":[]},"jq":{"W":[]},"iU":{"O":[]},"hu":{"ad":[]},"j6":{"W":[]},"b4":{"G":["1","2"],"a_":["1","2"],"G.V":"2","G.K":"1"},"b5":{"x":["1"],"n":["1"],"n.E":"1"},"bX":{"x":["1"],"n":["1"],"n.E":"1"},"aG":{"x":["M<1,2>"],"n":["M<1,2>"],"n.E":"M<1,2>"},"fn":{"b4":["1","2"],"G":["1","2"],"a_":["1","2"],"G.V":"2","G.K":"1"},"ex":{"j1":[],"d2":[]},"jF":{"n":["j1"],"n.E":"j1"},"fK":{"d2":[]},"kt":{"n":["d2"],"n.E":"d2"},"bF":{"ai":[],"v":[],"cO":[],"a1":[]},"dX":{"ai":[],"v":[],"cO":[],"a1":[]},"fw":{"ai":[],"v":[]},"kB":{"cO":[]},"fv":{"ai":[],"vk":[],"v":[],"a1":[]},"dY":{"b3":["1"],"ai":[],"v":[],"aF":["1"]},"cq":{"y":["Y"],"t":["Y"],"b3":["Y"],"ai":[],"x":["Y"],"v":[],"aF":["Y"],"n":["Y"]},"b8":{"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"]},"iL":{"cq":[],"mY":[],"y":["Y"],"t":["Y"],"b3":["Y"],"ai":[],"x":["Y"],"v":[],"aF":["Y"],"n":["Y"],"a1":[],"y.E":"Y"},"iM":{"cq":[],"mZ":[],"y":["Y"],"t":["Y"],"b3":["Y"],"ai":[],"x":["Y"],"v":[],"aF":["Y"],"n":["Y"],"a1":[],"y.E":"Y"},"iN":{"b8":[],"nC":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"iO":{"b8":[],"nD":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"iP":{"b8":[],"nE":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"iQ":{"b8":[],"pD":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"fx":{"b8":[],"pE":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"fy":{"b8":[],"pF":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"d3":{"b8":[],"bh":[],"y":["c"],"t":["c"],"b3":["c"],"ai":[],"x":["c"],"v":[],"aF":["c"],"n":["c"],"a1":[],"y.E":"c"},"jU":{"W":[]},"hx":{"c4":[],"W":[]},"a2":{"W":[]},"l":{"o":["1"]},"bZ":{"bH":["1"],"aj":["1"]},"bH":{"aj":["1"]},"aw":{"ae":["1"],"aw.T":"1"},"h0":{"cW":["1"]},"eD":{"n":["1"],"n.E":"1"},"aq":{"a4":["1"],"eC":["1"],"D":["1"],"D.T":"1"},"dk":{"cA":["1"],"aw":["1"],"ae":["1"],"aw.T":"1"},"c9":{"bH":["1"],"aj":["1"]},"du":{"c9":["1"],"bH":["1"],"aj":["1"]},"h1":{"c9":["1"],"bH":["1"],"aj":["1"]},"dZ":{"W":[]},"dl":{"cW":["1"]},"aa":{"dl":["1"],"cW":["1"]},"N":{"dl":["1"],"cW":["1"]},"fJ":{"D":["1"]},"cB":{"bH":["1"],"aj":["1"]},"bL":{"cB":["1"],"bH":["1"],"aj":["1"]},"cD":{"cB":["1"],"bH":["1"],"aj":["1"]},"a4":{"eC":["1"],"D":["1"],"D.T":"1"},"cA":{"aw":["1"],"ae":["1"],"aw.T":"1"},"eC":{"D":["1"]},"eo":{"ae":["1"]},"dp":{"D":["1"],"D.T":"1"},"bz":{"D":["1"],"D.T":"1"},"hh":{"bL":["1"],"cB":["1"],"bZ":["1"],"bH":["1"],"aj":["1"]},"bb":{"D":["2"]},"es":{"aw":["2"],"ae":["2"],"aw.T":"2"},"ce":{"bb":["1","1"],"D":["1"],"D.T":"1","bb.T":"1","bb.S":"1"},"aM":{"bb":["1","2"],"D":["2"],"D.T":"2","bb.T":"2","bb.S":"1"},"ha":{"aj":["1"]},"eA":{"aw":["2"],"ae":["2"],"aw.T":"2"},"c8":{"D":["2"],"D.T":"2"},"kE":{"B":[]},"jR":{"B":[]},"kn":{"B":[]},"eH":{"a9":[]},"cb":{"G":["1","2"],"a_":["1","2"],"G.V":"2","G.K":"1"},"dr":{"cb":["1","2"],"G":["1","2"],"a_":["1","2"],"G.V":"2","G.K":"1"},"h5":{"cb":["1","2"],"G":["1","2"],"a_":["1","2"],"G.V":"2","G.K":"1"},"hc":{"x":["1"],"n":["1"],"n.E":"1"},"hg":{"b4":["1","2"],"G":["1","2"],"a_":["1","2"],"G.V":"2","G.K":"1"},"cc":{"cu":["1"],"bu":["1"],"x":["1"],"n":["1"]},"d1":{"n":["1"],"n.E":"1"},"y":{"t":["1"],"x":["1"],"n":["1"]},"G":{"a_":["1","2"]},"fs":{"a_":["1","2"]},"df":{"fs":["1","2"],"kA":["1","2"],"a_":["1","2"]},"fq":{"X":["1"],"x":["1"],"n":["1"],"X.E":"1","n.E":"1"},"cu":{"bu":["1"],"x":["1"],"n":["1"]},"ht":{"cu":["1"],"bu":["1"],"x":["1"],"n":["1"]},"dm":{"aj":["1"]},"eu":{"aj":["j"]},"k2":{"G":["j","@"],"a_":["j","@"],"G.V":"@","G.K":"j"},"k3":{"X":["j"],"x":["j"],"n":["j"],"X.E":"j","n.E":"j"},"hT":{"cY":[]},"kz":{"ah":["j","t<c>"]},"hV":{"ah":["j","t<c>"],"ah.T":"t<c>"},"ky":{"ah":["t<c>","j"]},"hU":{"ah":["t<c>","j"],"ah.T":"j"},"hZ":{"ah":["t<c>","j"],"ah.T":"j"},"fo":{"W":[]},"iC":{"W":[]},"iE":{"ah":["k?","j"],"ah.T":"j"},"iD":{"ah":["j","k?"],"ah.T":"k?"},"iF":{"cY":[]},"iH":{"ah":["j","t<c>"],"ah.T":"t<c>"},"iG":{"ah":["t<c>","j"],"ah.T":"j"},"jx":{"cY":[]},"jz":{"ah":["j","t<c>"],"ah.T":"t<c>"},"jy":{"ah":["t<c>","j"],"ah.T":"j"},"wE":{"a7":["wE"]},"bT":{"a7":["bT"]},"Y":{"a7":["bQ"]},"b1":{"a7":["b1"]},"c":{"a7":["bQ"]},"t":{"x":["1"],"n":["1"]},"bQ":{"a7":["bQ"]},"j1":{"d2":[]},"bu":{"x":["1"],"n":["1"]},"j":{"a7":["j"]},"aA":{"a7":["wE"]},"hW":{"W":[]},"c4":{"W":[]},"a3":{"W":[]},"e1":{"W":[]},"fj":{"W":[]},"fR":{"W":[]},"jp":{"W":[]},"aX":{"W":[]},"ib":{"W":[]},"iV":{"W":[]},"fG":{"W":[]},"jV":{"O":[]},"aU":{"O":[]},"iw":{"O":[],"W":[]},"ku":{"ad":[]},"hD":{"jv":[]},"bk":{"jv":[]},"jS":{"jv":[]},"iT":{"O":[]},"U":{"a_":["2","3"]},"d9":{"eE":["1","bu<1>"],"eE.E":"1"},"ct":{"O":[]},"i_":{"lK":[]},"i4":{"lK":[]},"cP":{"D":["t<c>"],"D.T":"t<c>"},"bR":{"O":[]},"jl":{"cw":[]},"eZ":{"U":["j","j","1"],"a_":["j","1"],"U.K":"j","U.V":"1","U.C":"j"},"co":{"a7":["co"]},"iX":{"O":[]},"dc":{"O":[]},"f5":{"O":[]},"e_":{"O":[]},"cZ":{"dQ":[]},"bf":{"K":[]},"dH":{"O":[]},"hm":{"ca":[]},"ei":{"ca":[]},"h8":{"ca":[]},"fr":{"b9":[],"as":[]},"dN":{"as":[]},"fS":{"b9":[],"as":[]},"fd":{"b9":[],"as":[]},"dI":{"as":[]},"f9":{"b9":[],"as":[]},"f0":{"b9":[],"as":[]},"fh":{"b9":[],"as":[]},"fQ":{"b9":[],"as":[]},"eh":{"aj":["t<c>"]},"cs":{"aS":[]},"dK":{"aS":[]},"fU":{"aS":[]},"fP":{"aS":[]},"fg":{"aS":[]},"f1":{"aS":[]},"e2":{"lK":[]},"fZ":{"bO":[]},"hs":{"bO":[]},"h7":{"bO":[]},"h4":{"bO":[]},"i8":{"O":[]},"ir":{"bv":[],"a7":["bv"]},"er":{"c2":[],"a7":["jd"]},"bv":{"a7":["bv"]},"jc":{"bv":[],"a7":["bv"]},"jd":{"a7":["jd"]},"je":{"a7":["jd"]},"jf":{"O":[]},"e5":{"aU":[],"O":[]},"e6":{"a7":["jd"]},"c2":{"a7":["jd"]},"da":{"O":[]},"e8":{"cU":[]},"it":{"aC":[]},"k_":{"fW":[],"aO":[]},"bG":{"y":["aW"],"t":["aW"],"x":["aW"],"n":["aW"],"y.E":"aW"},"aW":{"js":["j","@"],"G":["j","@"],"a_":["j","@"],"G.V":"@","G.K":"j"},"c6":{"O":[]},"i2":{"aC":[]},"i1":{"fW":[],"aO":[]},"dj":{"aH":["dj"],"aH.E":"dj"},"ed":{"y":["cx"],"t":["cx"],"x":["cx"],"n":["cx"],"y.E":"cx"},"eW":{"D":["1"],"D.T":"1"},"cl":{"aC":[]},"aE":{"aH":["aE"]},"k0":{"fW":[],"aO":[]},"hb":{"aE":[],"aH":["aE"],"aH.E":"aE"},"h6":{"aE":[],"aH":["aE"],"aH.E":"aE"},"em":{"aE":[],"aH":["aE"],"aH.E":"aE"},"eG":{"aE":[],"aH":["aE"],"aH.E":"aE"},"e4":{"aC":[]},"kq":{"fW":[],"aO":[]},"f_":{"O":[]},"j3":{"wN":[]},"cj":{"y":["k?"],"t":["k?"],"x":["k?"],"n":["k?"],"y.E":"k?"},"bq":{"O":[]},"d6":{"O":[]},"ej":{"wK":[]},"iJ":{"W":[]},"jh":{"aK":[],"aB":[]},"ji":{"aK":[],"aB":[]},"bC":{"O":[]},"jt":{"aB":[]},"fC":{"aB":[]},"fD":{"aK":[],"aB":[]},"aK":{"aB":[]},"jg":{"aK":[],"aB":[]},"cd":{"aB":[]},"jA":{"vK":[],"aK":[],"aB":[]},"hY":{"cy":[]},"jn":{"aU":[],"O":[]},"bg":{"ea":["c"],"y":["c"],"t":["c"],"x":["c"],"n":["c"],"y.E":"c"},"ea":{"y":["1"],"t":["1"],"x":["1"],"n":["1"]},"k1":{"ea":["c"],"y":["c"],"t":["c"],"x":["c"],"n":["c"]},"ep":{"D":["1"],"D.T":"1"},"eq":{"ae":["1"]},"nE":{"t":["c"],"x":["c"],"n":["c"]},"bh":{"t":["c"],"x":["c"],"n":["c"]},"pF":{"t":["c"],"x":["c"],"n":["c"]},"nC":{"t":["c"],"x":["c"],"n":["c"]},"pD":{"t":["c"],"x":["c"],"n":["c"]},"nD":{"t":["c"],"x":["c"],"n":["c"]},"pE":{"t":["c"],"x":["c"],"n":["c"]},"mY":{"t":["Y"],"x":["Y"],"n":["Y"]},"mZ":{"t":["Y"],"x":["Y"],"n":["Y"]},"vK":{"aK":[],"aB":[]}}'))
A.CA(v.typeUniverse,JSON.parse('{"ef":1,"j9":1,"ii":1,"iS":1,"ff":1,"jr":1,"eb":1,"hG":2,"f3":1,"d0":1,"b6":1,"dY":1,"aj":1,"kv":1,"dZ":2,"fJ":1,"jk":2,"kw":1,"jJ":1,"h_":1,"ks":1,"jT":1,"bx":1,"ey":1,"bP":1,"ha":1,"kr":2,"ht":1,"hC":2,"dm":2,"i9":1,"ia":2,"hw":1,"io":1,"fV":1,"f8":1,"iR":1,"fu":1,"A5":1}'))
var u={S:"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\u03f6\x00\u0404\u03f4 \u03f4\u03f6\u01f6\u01f6\u03f6\u03fc\u01f4\u03ff\u03ff\u0584\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u05d4\u01f4\x00\u01f4\x00\u0504\u05c4\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u0400\x00\u0400\u0200\u03f7\u0200\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u03ff\u0200\u0200\u0200\u03f7\x00",D:" must not be greater than the number of characters in the file, ",U:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",l:"Applying checkpoint is blocked on local mutations, but no uploader is set. The sync client cannot proceed.",t:"Broadcast stream controllers do not support pause callbacks",O:"Cannot change the length of a fixed-length list",A:"Cannot extract a file path from a URI with a fragment component",z:"Cannot extract a file path from a URI with a query component",Q:"Cannot extract a non-Windows file path from a file URI with an authority",c:"Cannot fire new event. Controller is already firing an event",w:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",B:"SELECT seq FROM main.sqlite_sequence WHERE name = 'ps_crud'",f:"Tried to operate on a released prepared statement",y:"handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace.",E:"max must be in range 0 < max \u2264 2^32, was "}
var t=(function rtii(){var s=A.am
return{fM:s("@<@>"),fN:s("bq"),ie:s("A5<k?>"),om:s("eW<w<k?>>"),lo:s("cO"),fW:s("vk"),kj:s("eZ<j>"),h6:s("wJ"),eg:s("wK"),dF:s("lK()"),V:s("br"),fw:s("cU"),bP:s("a7<@>"),p6:s("cV"),br:s("cW<v>"),kn:s("cW<k?>"),A:s("cW<~>"),hM:s("ci"),em:s("dL"),kS:s("wN"),lp:s("ig"),O:s("x<@>"),C:s("W"),L:s("O"),eZ:s("ip"),pk:s("mY"),kI:s("mZ"),lW:s("aU"),gY:s("Fc"),nW:s("o<v>"),mj:s("o<F>"),nK:s("o<+(k?,w<k?>?)>"),fP:s("o<bV?>"),cI:s("o<j?>"),jN:s("o<ec?>"),p8:s("o<~>"),cF:s("cl"),m6:s("nC"),bW:s("nD"),g2:s("dQ"),jx:s("nE"),ks:s("n<as>"),e7:s("n<@>"),en:s("w<o<@>>"),M:s("w<o<~>>"),kG:s("w<v>"),dO:s("w<t<k?>>"),hf:s("w<k>"),fU:s("w<+controller,sync(bZ<ba>,H)>"),lw:s("w<+controller,sync(bZ<~>,H)>"),kC:s("w<+(cv,j)>"),iE:s("w<+(j,k?)>"),bN:s("w<+name,parameters(j,j)>"),cH:s("w<+hasSynced,lastSyncedAt,priority(H?,bT?,c)>"),lE:s("w<e8>"),a6:s("w<ae<K>>"),bO:s("w<ae<~>>"),fu:s("w<D<aS>>"),i3:s("w<D<~>>"),s:s("w<j>"),az:s("w<ej>"),ba:s("w<ek>"),dB:s("w<bN<@>>"),g7:s("w<aP>"),dg:s("w<by>"),o6:s("w<k7>"),jI:s("w<dv>"),gk:s("w<Y>"),dG:s("w<@>"),t:s("w<c>"),b9:s("w<a2?>"),c:s("w<k?>"),mf:s("w<j?>"),iy:s("aF<@>"),v:s("dR"),m:s("v"),bJ:s("aQ"),g:s("b2"),dX:s("b3<@>"),d9:s("ai"),kk:s("d1<dj>"),p3:s("d1<aE>"),mu:s("t<w<k?>>"),ip:s("t<v>"),eL:s("t<+name,parameters(j,j)>"),k:s("t<j>"),j:s("t<@>"),f4:s("t<c>"),ia:s("t<k?>"),fi:s("t<j?>"),ag:s("dU"),W:s("dV"),gc:s("M<j,j>"),lx:s("M<j,+atLast,priority,sinceLast,targetCount(c,c,c,c)>"),ea:s("a_<j,@>"),dV:s("a_<j,c>"),av:s("a_<@,@>"),f:s("a_<j,k?>"),iZ:s("a8<j,@>"),eK:s("a8<+(j,k?),j>"),jC:s("Fg"),a:s("bF"),dQ:s("cq"),aj:s("b8"),Z:s("d3"),Y:s("b9"),bC:s("fz<o<~>>"),P:s("F"),K:s("k"),lZ:s("Fj"),aK:s("+()"),U:s("+immediateRestart(H)"),ja:s("+(v,dJ)"),iS:s("+(v,F)"),lg:s("+(F,F)"),k0:s("+(k,F)"),cU:s("+(cv,j)"),E:s("+name,parameters(j,j)"),l4:s("+(af,k)"),mk:s("+(H,v)"),kO:s("+basicSupport,supportsReadWriteUnsafe(H,H)"),mt:s("+(v?,v)"),jc:s("+(bF?,w<k?>?)"),iu:s("+(k?,w<k?>?)"),ii:s("+autocommit,lastInsertRowid,result(H,c,bG)"),cV:s("+atLast,priority,sinceLast,targetCount(c,c,c,c)"),lu:s("j1"),b:s("e3"),G:s("bG"),hF:s("d8<j>"),oy:s("aW"),g_:s("e4"),hq:s("bv"),ol:s("c2"),e1:s("ba"),l:s("ad"),ao:s("bH<K>"),a9:s("fI<bO>"),ha:s("ae<ba>"),ey:s("ae<~>"),ir:s("D<bO>"),n:s("cw"),N:s("j"),of:s("a0"),o:s("aS"),jM:s("dc"),mO:s("e9"),k4:s("aL"),hU:s("fO"),aJ:s("a1"),do:s("c4"),i7:s("pD"),mC:s("pE"),oR:s("bg"),nn:s("pF"),p:s("bh"),cx:s("de"),ph:s("df<j,j>"),d:s("K"),R:s("jv"),e6:s("aC"),j2:s("fW"),w:s("ec"),m1:s("vK"),lS:s("fX<j>"),u:s("cy"),iq:s("aa<bh>"),ho:s("aa<c>"),if:s("aa<ci?>"),mE:s("aa<k?>"),h:s("aa<~>"),it:s("c8<@,j>"),jB:s("c8<@,bh>"),hi:s("ca"),fK:s("el"),Q:s("dn<v>"),hV:s("dp<K>"),d4:s("ep<v>"),nI:s("l<fi>"),fV:s("l<bV>"),a7:s("l<v>"),e:s("l<0&>"),jz:s("l<bh>"),B:s("l<H>"),_:s("l<@>"),hy:s("l<c>"),iB:s("l<ci?>"),ny:s("l<k?>"),D:s("l<~>"),nf:s("aP"),mp:s("dr<k?,k?>"),fA:s("ew"),fb:s("bz<t<c>>"),cn:s("bz<bu<j>>"),pp:s("bO"),jy:s("cC<ba,~()>"),af:s("cC<~,H()>"),lU:s("cC<~,~()>"),aP:s("N<fi>"),l6:s("N<bV>"),h1:s("N<v>"),ex:s("N<H>"),gW:s("N<k?>"),F:s("N<~>"),y:s("H"),i:s("Y"),z:s("@"),mq:s("@(k)"),ng:s("@(k,ad)"),S:s("c"),gO:s("ci?"),d_:s("f6?"),gK:s("o<F>?"),m2:s("o<~>?"),b3:s("bV?"),fo:s("dQ?"),mU:s("v?"),h9:s("a_<j,k?>?"),aC:s("bF?"),X:s("k?"),J:s("cr?"),x:s("aW?"),mQ:s("ae<bO>?"),T:s("j?"),a_:s("bg?"),he:s("ec?"),dd:s("aP?"),o9:s("H?"),jX:s("Y?"),I:s("c?"),jh:s("bQ?"),q:s("bQ"),H:s("~"),cj:s("~()"),i6:s("~(k)"),r:s("~(k,ad)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.bk=J.ix.prototype
B.c=J.w.prototype
B.b=J.fl.prototype
B.ab=J.dR.prototype
B.ac=J.dS.prototype
B.a=J.cm.prototype
B.bl=J.b2.prototype
B.bm=J.ai.prototype
B.ag=A.fv.prototype
B.M=A.fx.prototype
B.f=A.d3.prototype
B.ah=J.iY.prototype
B.a_=J.de.prototype
B.B=new A.bq("Operation was cancelled",null)
B.a1=new A.hU(!1,127)
B.aK=new A.hV(127)
B.b3=new A.dp(A.am("dp<t<c>>"))
B.aL=new A.cP(B.b3)
B.aM=new A.fk(A.EM(),A.am("fk<c>"))
B.cc=new A.hZ()
B.aN=new A.lg()
B.aO=new A.i8()
B.aP=new A.f0()
B.C=new A.f8()
B.aQ=new A.f9()
B.a2=new A.ii()
B.aR=new A.iw()
B.a3=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.aS=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.aX=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.aT=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.aW=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.aV=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.aU=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.a4=function(hooks) { return hooks; }

B.h=new A.nK()
B.k=new A.iF()
B.r=new A.fp()
B.aY=new A.nL()
B.y=new A.iK(A.am("iK<j,@>"))
B.aZ=new A.iV()
B.e=new A.ox()
B.b0=new A.d9(A.am("d9<j>"))
B.b_=new A.d9(A.am("d9<+name,parameters(j,j)>"))
B.b1=new A.fP()
B.a5=new A.fU()
B.l=new A.jx()
B.o=new A.jz()
B.b2=new A.ro()
B.z=new A.rq()
B.a6=new A.h8()
B.b4=new A.rY()
B.D=new A.hm()
B.d=new A.kn()
B.t=new A.ku()
B.b5=new A.tO()
B.b6=new A.tP()
B.b7=new A.dH("The PowerSync service does not support checkpoint requests. Update to PowerSync service version 1.24.0 or later to use this API.")
B.A=new A.dH("Cannot request checkpoints, sync client is disconnected")
B.b8=new A.dH("Connected with legacy checkpoint mode, cannot request checkpoints")
B.b9=new A.dK(0,"established")
B.ba=new A.dK(1,"end")
B.E=new A.bS(3,"updateSubscriptionManagement")
B.F=new A.bS(4,"notifyUpdates")
B.a7=new A.b1(0)
B.G=new A.b1(1e4)
B.u=new A.b1(5e6)
B.H=new A.ck("x",1,"opfsExternalLocks")
B.a8=new A.ck("y",2,"opfsExternalLocksWorkaround")
B.a9=new A.dO("/database",0,"database")
B.aa=new A.dO("/database-journal",1,"journal")
B.bn=new A.iD(null)
B.bo=new A.iE(null)
B.ad=new A.iG(!1,255)
B.bp=new A.iH(255)
B.p=new A.co("FINE",500)
B.m=new A.co("INFO",800)
B.i=new A.co("WARNING",900)
B.O=new A.af(0,"ping")
B.aq=new A.af(1,"startSynchronization")
B.aA=new A.af(2,"updateSubscriptions")
B.aB=new A.af(3,"abortSynchronization")
B.Q=new A.af(4,"requestEndpoint")
B.R=new A.af(5,"uploadCrud")
B.aC=new A.af(6,"customCheckpointRequest")
B.aD=new A.af(7,"requestCheckpoint")
B.S=new A.af(8,"invalidCredentialsCallback")
B.T=new A.af(9,"credentialsCallback")
B.P=new A.af(10,"prefetchCredentialsCallback")
B.ar=new A.af(11,"abortRequest")
B.as=new A.af(12,"notifySyncStatus")
B.at=new A.af(13,"handleDiagnostics")
B.au=new A.af(14,"logEvent")
B.av=new A.af(15,"sendHttpRequest")
B.aw=new A.af(16,"abortHttpRequest")
B.ax=new A.af(17,"readResponseChunk")
B.ay=new A.af(18,"okResponse")
B.az=new A.af(19,"errorResponse")
B.bq=s([B.O,B.aq,B.aA,B.aB,B.Q,B.R,B.aC,B.aD,B.S,B.T,B.P,B.ar,B.as,B.at,B.au,B.av,B.aw,B.ax,B.ay,B.az],A.am("w<af>"))
B.br=s([239,191,189],t.t)
B.x=new A.bw(0,"unknown")
B.U=new A.bw(1,"integer")
B.V=new A.bw(2,"bigInt")
B.W=new A.bw(3,"float")
B.X=new A.bw(4,"text")
B.Y=new A.bw(5,"blob")
B.Z=new A.bw(6,"$null")
B.aE=new A.bw(7,"boolean")
B.I=s([B.x,B.U,B.V,B.W,B.X,B.Y,B.Z,B.aE],A.am("w<bw>"))
B.bs=s([65533],t.t)
B.bi=new A.fe(0,"database")
B.bj=new A.fe(1,"journal")
B.ae=s([B.bi,B.bj],A.am("w<fe>"))
B.bh=new A.ck("s",0,"opfsShared")
B.bf=new A.ck("i",3,"indexedDb")
B.bg=new A.ck("m",4,"inMemory")
B.bt=s([B.bh,B.H,B.a8,B.bf,B.bg],A.am("w<ck>"))
B.bb=new A.bS(0,"ok")
B.bc=new A.bS(1,"getAutoCommit")
B.bd=new A.bS(2,"executeBatch")
B.be=new A.bS(5,"installBroadcastUpdates")
B.af=s([B.bb,B.bc,B.bd,B.E,B.F,B.be],A.am("w<bS>"))
B.ak=new A.e7(0,"insert")
B.al=new A.e7(1,"update")
B.am=new A.e7(2,"delete")
B.bu=s([B.ak,B.al,B.am],A.am("w<e7>"))
B.J=s([],t.s)
B.bw=s([],t.t)
B.n=s([],t.c)
B.bv=s([],t.bN)
B.bx=s([B.a9,B.aa],A.am("w<dO>"))
B.an=new A.cv(0,"opfs")
B.ao=new A.cv(1,"indexedDb")
B.bG=new A.cv(2,"inMemory")
B.by=s([B.an,B.ao,B.bG],A.am("w<cv>"))
B.bD={"iso_8859-1:1987":0,"iso-ir-100":1,"iso_8859-1":2,"iso-8859-1":3,latin1:4,l1:5,ibm819:6,cp819:7,csisolatin1:8,"iso-ir-6":9,"ansi_x3.4-1968":10,"ansi_x3.4-1986":11,"iso_646.irv:1991":12,"iso646-us":13,"us-ascii":14,us:15,ibm367:16,cp367:17,csascii:18,ascii:19,csutf8:20,"utf-8":21}
B.j=new A.hT()
B.bz=new A.b0(B.bD,[B.k,B.k,B.k,B.k,B.k,B.k,B.k,B.k,B.k,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.j,B.l,B.l],A.am("b0<j,cY>"))
B.v={}
B.L=new A.b0(B.v,[],A.am("b0<j,j>"))
B.bA=new A.b0(B.v,[],A.am("b0<j,c>"))
B.K=new A.b0(B.v,[],A.am("b0<j,@>"))
B.q=new A.fu(11,"simpleSuccessResponse")
B.bC=new A.fu(13,"rowsResponse")
B.cd=new A.o1(2,"readWriteCreate")
B.ai=new A.ho(!1)
B.aj=new A.Q(null,null)
B.N=new A.hp(!1,!1)
B.bE=new A.hr("BEGIN IMMEDIATE","COMMIT","ROLLBACK")
B.bF=new A.f4(B.v,0,A.am("f4<j>"))
B.bH=new A.fL("_clientToken")
B.w=new A.fL("reset")
B.ap=new A.pe(0,"rust")
B.bI=A.bp("cO")
B.bJ=A.bp("vk")
B.bK=A.bp("mY")
B.bL=A.bp("mZ")
B.bM=A.bp("nC")
B.bN=A.bp("nD")
B.bO=A.bp("nE")
B.bP=A.bp("v")
B.bQ=A.bp("k")
B.bR=A.bp("pD")
B.bS=A.bp("pE")
B.bT=A.bp("pF")
B.bU=A.bp("bh")
B.bV=new A.fT("DELETE",2,"delete")
B.bW=new A.fT("PATCH",1,"patch")
B.bX=new A.fT("PUT",0,"put")
B.aF=new A.jy(!1)
B.bY=new A.c6(14)
B.bZ=new A.c6(522)
B.c_=new A.c6(778)
B.aG=new A.eB("canceled")
B.aH=new A.eB("dormant")
B.aI=new A.eB("listening")
B.aJ=new A.eB("paused")
B.c0=new A.tQ(B.d,A.E0())
B.c1=new A.tR(B.d,A.E1())
B.c2=new A.tS(B.d,A.E2())
B.c3=new A.kF(B.d,A.E3())
B.c4=new A.tT(B.d,A.E4())
B.c5=new A.tU(B.d,A.E5())
B.c6=new A.tV(B.d,A.E6())
B.c7=new A.tW(B.d,A.E7())
B.c8=new A.tY(B.d,A.E9())
B.c9=new A.tZ(B.d,A.Ea())
B.ca=new A.tX(B.d,A.E8())
B.cb=new A.kG(B.d,A.Eb())
B.bB=new A.b0(B.v,[],A.am("b0<k?,k?>"))
B.a0=new A.kH(B.d,B.bB)})();(function staticFields(){$.t_=null
$.dy=A.u([],t.hf)
$.Dy=null
$.xd=null
$.wH=null
$.wG=null
$.yY=null
$.yR=null
$.z7=null
$.uE=null
$.uQ=null
$.wm=null
$.tc=A.u([],A.am("w<t<k>?>"))
$.eM=null
$.hI=null
$.hJ=null
$.wc=!1
$.m=B.d
$.te=null
$.xJ=null
$.xK=null
$.xL=null
$.xM=null
$.vO=A.qZ("_lastQuoRemDigits")
$.vP=A.qZ("_lastQuoRemUsed")
$.h2=A.qZ("_lastRemUsed")
$.vQ=A.qZ("_lastRem_nsh")
$.xE=""
$.xF=null
$.eL=0
$.eI=A.T(t.N,t.S)
$.x4=0
$.AX=A.T(t.N,t.W)
$.ys=null
$.u8=null})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"Fa","zk",()=>A.uI("_$dart_dartClosure"))
s($,"F9","dD",()=>A.uI("_$dart_dartClosure_dartJSInterop"))
s($,"G7","zQ",()=>B.d.bv(new A.v2(),t.p8))
s($,"G0","zN",()=>A.u([new J.iy()],A.am("w<fB>")))
s($,"Fr","zo",()=>A.c5(A.pC({
toString:function(){return"$receiver$"}})))
s($,"Fs","zp",()=>A.c5(A.pC({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"Ft","zq",()=>A.c5(A.pC(null)))
s($,"Fu","zr",()=>A.c5(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"Fx","zu",()=>A.c5(A.pC(void 0)))
s($,"Fy","zv",()=>A.c5(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"Fw","zt",()=>A.c5(A.xB(null)))
s($,"Fv","zs",()=>A.c5(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"FA","zx",()=>A.c5(A.xB(void 0)))
s($,"Fz","zw",()=>A.c5(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"FC","ws",()=>A.BM())
s($,"Fe","cK",()=>$.zQ())
s($,"Fd","zl",()=>A.C4(!1,B.d,t.y))
s($,"FM","zD",()=>A.B0(4096))
s($,"FK","zB",()=>new A.tL().$0())
s($,"FL","zC",()=>new A.tK().$0())
s($,"FD","zy",()=>A.AZ(A.w8(A.u([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.t))))
s($,"FI","ch",()=>A.qQ(0))
s($,"FH","kX",()=>A.qQ(1))
s($,"FF","wu",()=>$.kX().bz(0))
s($,"FE","wt",()=>A.qQ(1e4))
r($,"FG","zz",()=>A.au("^\\s*([+-]?)((0x[a-f0-9]+)|(\\d+)|([a-z0-9]+))\\s*$",!1))
s($,"FJ","zA",()=>typeof FinalizationRegistry=="function"?FinalizationRegistry:null)
s($,"FP","eU",()=>A.kT(B.bQ))
r($,"FW","kY",()=>new A.uf().$0())
r($,"FT","zI",()=>new A.ud().$0())
s($,"FS","zH",()=>Symbol("jsBoxedDartObjectProperty"))
s($,"Fi","zm",()=>{var q=new A.rZ(A.AY(8))
q.l8()
return q})
s($,"F7","zj",()=>A.au("^[\\w!#%&'*+\\-.^`|~]+$",!0))
s($,"FO","zE",()=>A.au('["\\x00-\\x1F\\x7F]',!0))
s($,"G8","zR",()=>A.au('[^()<>@,;:"\\\\/[\\]?={} \\t\\x00-\\x1F\\x7F]+',!0))
s($,"FV","zJ",()=>A.au("(?:\\r\\n)?[ \\t]+",!0))
s($,"FY","zL",()=>A.au('"(?:[^"\\x00-\\x1F\\x7F\\\\]|\\\\.)*"',!0))
s($,"FX","zK",()=>A.au("\\\\(.)",!0))
s($,"G6","zP",()=>A.au('[()<>@,;:"\\\\/\\[\\]?={} \\t\\x00-\\x1F\\x7F]',!0))
s($,"G9","zS",()=>A.au("(?:"+$.zJ().a+")*",!0))
s($,"Ff","vh",()=>A.vz(""))
s($,"G4","ww",()=>new A.m0($.wr()))
s($,"Fo","zn",()=>new A.o3(A.au("/",!0),A.au("[^/]$",!0),A.au("^/",!0)))
s($,"Fq","kW",()=>new A.qi(A.au("[/\\\\]",!0),A.au("[^/\\\\]$",!0),A.au("^(\\\\\\\\[^\\\\]+\\\\[^\\\\/]+|[a-zA-Z]:[/\\\\])",!0),A.au("^[/\\\\](?![/\\\\])",!0)))
s($,"Fp","hN",()=>new A.pP(A.au("/",!0),A.au("(^[a-zA-Z][-+.a-zA-Z\\d]*://|[^/])$",!0),A.au("[a-zA-Z][-+.a-zA-Z\\d]*://[^/]*",!0),A.au("^/",!0)))
s($,"Fn","wr",()=>A.Bs())
s($,"G3","wv",()=>A.Ds())
s($,"FU","cL",()=>$.wv())
s($,"FR","zG",()=>A.x_(A.yZ(),"SharedWorkerGlobalScope"))
s($,"FQ","zF",()=>A.x_(A.yZ(),"DedicatedWorkerGlobalScope"))
s($,"F8","kV",()=>$.zm())
s($,"G1","zO",()=>A.AV(A.u([A.vF("files"),A.vF("blocks")],t.s)))
s($,"Fb","vg",()=>{var q,p,o=A.T(t.N,A.am("dO"))
for(q=0;q<2;++q){p=B.bx[q]
o.l(0,p.c,p)}return o})
s($,"FZ","zM",()=>A.B9())
r($,"FB","hO",()=>{var q="navigator"
return A.AN(A.AO(A.uK(A.za(),q),A.vF("locks")))?A.uK(A.uK(A.za(),q),"locks"):null})})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({SharedArrayBuffer:A.dX,ArrayBuffer:A.bF,ArrayBufferView:A.fw,DataView:A.fv,Float32Array:A.iL,Float64Array:A.iM,Int16Array:A.iN,Int32Array:A.iO,Int8Array:A.iP,Uint16Array:A.iQ,Uint32Array:A.fx,Uint8ClampedArray:A.fy,CanvasPixelArray:A.fy,Uint8Array:A.d3})
hunkHelpers.setOrUpdateLeafTags({SharedArrayBuffer:true,ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.dY.$nativeSuperclassTag="ArrayBufferView"
A.hi.$nativeSuperclassTag="ArrayBufferView"
A.hj.$nativeSuperclassTag="ArrayBufferView"
A.cq.$nativeSuperclassTag="ArrayBufferView"
A.hk.$nativeSuperclassTag="ArrayBufferView"
A.hl.$nativeSuperclassTag="ArrayBufferView"
A.b8.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$2$2=function(a,b){return this(a,b)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$2$1=function(a){return this(a)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$3$1=function(a){return this(a)}
Function.prototype.$1$2=function(a,b){return this(a,b)}
Function.prototype.$2$0=function(){return this()}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$3$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$2$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$3$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
Function.prototype.$2$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$2$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$1$0=function(){return this()}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.EK
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=powersync_db.worker.js.map
