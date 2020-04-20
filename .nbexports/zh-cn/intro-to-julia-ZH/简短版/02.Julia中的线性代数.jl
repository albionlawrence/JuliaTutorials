
# ------------------------------------------------------------------------------------------
# # Julia 中的线性代数
# > Based on work by Andreas Noack Jensen
#
# ## 目录
#  - [基础线性代数操作](#基础线性代数操作)
#     - [乘法](#乘法)
#     - [转置](#转置)
#     - [转置的乘法](#转置的乘法)
#     - [解线性方程组](#解线性方程组)
#  - [特殊的矩阵结构](#特殊的矩阵结构)
#      - [大规模问题](#大规模问题)
# ------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
# ## 基础线性代数操作
# 定义一个随机矩阵
# ------------------------------------------------------------------------------------------

A = rand(1:4,3,3)

# ------------------------------------------------------------------------------------------
# 定义一个元素全为 1 的向量
# ------------------------------------------------------------------------------------------

x = fill(1.0, (3))

# ------------------------------------------------------------------------------------------
# 注意 $A$ 的类型为 `Array{Int64,2}`，而 $x$ 的类型为 `Array{Float64,1}`。
#
# Julia 定义 `Array{Type,1}` 的别名为向量 `Vector{Type}`，`Array{Type,2}` 的别名为矩阵 `Matrix{Type}` 。
#
# 许多线性代数的基础操作和其他语言一样
#
# ### 乘法
# ------------------------------------------------------------------------------------------

b = A*x

# ------------------------------------------------------------------------------------------
# ### 转置
# 就像在其他语言中 `A'` 表示对 `A` 进行共轭转置
# ------------------------------------------------------------------------------------------

A'

# ------------------------------------------------------------------------------------------
# 我们还可以通过 `transpose` 函数获得转置矩阵
# ------------------------------------------------------------------------------------------

transpose(A)

# ------------------------------------------------------------------------------------------
# ### 转置的乘法
# Julia 中某些情况下可以省略 `*` 号
# ------------------------------------------------------------------------------------------

A'A

# ------------------------------------------------------------------------------------------
# ### 解线性方程组
# 用方阵 $A$ 表示的线性方程组 $Ax=b$ 可以用左除运算符（函数）`\` 求解
# ------------------------------------------------------------------------------------------

A\b

# ------------------------------------------------------------------------------------------
# ## 特殊的矩阵结构
#
# 矩阵结构在线性代数中非常重要。
# 接触一下大一些的线型系统就可以看到矩阵结构有*多*重要了。
#
# 用线性代数标准包 `LinearAlgebra` 可以获得结构化的矩阵（structured matrices）：
# ------------------------------------------------------------------------------------------

using LinearAlgebra

n = 1000
A = randn(n,n);

# ------------------------------------------------------------------------------------------
# Julia 可以推断特殊矩阵结构，比如判断对称矩阵
# ------------------------------------------------------------------------------------------

Asym = A + A'
issymmetric(Asym)

# ------------------------------------------------------------------------------------------
# 但有时候浮点错误会比较麻烦
# ------------------------------------------------------------------------------------------

Asym_noisy = copy(Asym)
Asym_noisy[1,2] += 5eps()

issymmetric(Asym_noisy)

# ------------------------------------------------------------------------------------------
# 幸运的是我们可以通过如 `Diagonal`，`Triangular`，`Symmetric`，`Hermitian`，`Tridiagonal`
# 和 `SymTridiagonal` 这样的函数来明确地创建矩阵
# ------------------------------------------------------------------------------------------

Asym_explicit = Symmetric(Asym_noisy);

# ------------------------------------------------------------------------------------------
# 我们来看看 Julia 计算 `Asym`，`Asym_noisy` 和 `Asym_explicit` 的特征值各要花多少时间
# ------------------------------------------------------------------------------------------

@time eigvals(Asym);

@time eigvals(Asym_noisy);

@time eigvals(Asym_explicit);

# ------------------------------------------------------------------------------------------
#
# 本例中，使用 `Symmetric()` 处理 `Asym_noisy` 后让计算效率提高了约5倍
# ------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
# ### 大规模问题
# 使用 `Tridiagonal` 和 `SymTridiagonal` 类型储存三对角矩阵（tridiagonal matrices）
# 让处理大规模的三对角矩阵问题变为可能。
#
# 以下问题如果使用稠密的 `Matrix` 类型储存，在个人计算机上是无法进行求解的。
# ------------------------------------------------------------------------------------------

n = 1_000_000;
A = SymTridiagonal(randn(n), randn(n-1));
@time eigmax(A)
