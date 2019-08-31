require 'csv'

# 密漁警備ゲーム

# 警備箇所のサイズ
TARGET_SIZE = 5

# 警備員の人数

MEMBER = 2

# 密漁者による密漁箇所の個数
ATTACK_POINT = 1

# 密漁者・警備側の利得よりも十分大きな値
Z = 1000

# 制約を満たさない時に返す値
FALSE_VALUE = -100000000000000

# 警備した場合の利得

def utility_table_for_defense(c)
  if c == 1
    return 5
  else
    return -20
  end
end

# 密漁した場合の利得
def utility_table_for_attack(c)
  if c == 1
    return -10
  else
    return 30
  end
end

# 警備側の全体的な利得
def utility_for_defense(c_vec, t)
  return (c_vec[t] * utility_table_for_defense(1) + (1 - c_vec[t] * utility_table_for_defense(0)))
end

# 密漁側の全体的な利得
def utility_for_attack(c_vec, t)
  return (c_vec[t] * utility_table_for_attack(1) + (1 - c_vec[t] * utility_table_for_attack(0)))
end

# 攻撃ベクトルが与えられた際の、警備側の期待利得
def d_func(c_vec, a_vec)
  sum = 0
  TARGET_SIZE.times do |t|
    sum += a_vec[t] * utility_for_defense(c_vec, t)
  end
  return sum
end

# 攻撃ベクトルが与えられた際の、警備側の期待利得
def k_func(c_vec, a_vec)
  sum = 0
  TARGET_SIZE.times do |t|
    sum += a_vec[t] * utility_for_attack(c_vec, t)
  end
  return sum
end

def main(c_vec, a_vec)
  flag = true

  d = d_func(c_vec, a_vec)
  k = k_func(c_vec, a_vec)

  c_sum = c_vec.sum

  if !(c_sum <= MEMBER)
    return FALSE_VALUE
  end

  a_sum = a_vec.sum
  if !(c_sum <= MEMBER)
    return FALSE_VALUE
  end

  TARGET_SIZE.times do |t|
    dd = d - utility_for_defense(c_vec, t)
    zz = (1 - a_vec[t]) * Z
    if !(dd <= zz)
      return FALSE_VALUE
    end
  end

  TARGET_SIZE.times do |t|
    kk = k - utility_for_attack(c_vec, t)
    zz = (1 - a_vec[t]) * Z
    if !(0 <= kk && kk <= zz)
      return FALSE_VALUE
    end
  end
  return d
end

c = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
a = [0, 1]

d_max = FALSE_VALUE

c.product(c,c,c,c).each do |c_vec|
  a.product(a,a,a,a).each do |a_vec|
    d = main(c_vec, a_vec)
    if d_max <= d
      if d_max < d
        puts ''
      end
      puts "#{c_vec}, #{a_vec}, #{d}"
      d_max = d
    end
  end
end
