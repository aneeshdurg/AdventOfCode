_SNAFUToDecimal s = _SNAFUToDecimal_helper ((length s) - 1) s
  where decimal_value x = case x of
          '=' -> -2
          '-' -> -1
          '0' -> 0
          '1' -> 1
          '2' -> 2
        _SNAFUToDecimal_helper n [] = 0
        _SNAFUToDecimal_helper n (x:xs) =
          5^n * (decimal_value x) + _SNAFUToDecimal_helper (n - 1) xs

negateSNAFU :: [Char] -> [Char]
negateSNAFU [] = []
negateSNAFU (x:xs) = [negate_char x] ++ negateSNAFU xs
  where negate_char x = case x of
          '=' -> '2'
          '-' -> '1'
          '0' -> '0'
          '1' -> '-'
          '2' -> '='

_SNAFUMax 0 = 0
_SNAFUMax n = 2 * 5 ^ (n - 1) + _SNAFUMax (n - 1)

_SNAFUDigitsRequired x =
  if n_max >= x
    then n
  else (n + 1)
  where n = ceiling $ (log (fromIntegral x)) / (log 5)
        n_max = _SNAFUMax n

toSNAFU x = toSNAFUHelper x (_SNAFUDigitsRequired x)
  where toSNAFUHelper _ 0 = []
        toSNAFUHelper 0 n = take n $ repeat '0'
        toSNAFUHelper x n
          | x < 0 = negateSNAFU $ toSNAFUHelper (-x) n
          | x < pwr = if (pwr - x) < _SNAFUMax (n - 1)
              then ['1'] ++ negateSNAFU (toSNAFUHelper (pwr - x) (n - 1))
              else ['0'] ++ toSNAFUHelper x (n - 1)
          | x >= pwr = if (x - pwr) > _SNAFUMax (n - 1)
            then ['2'] ++ negateSNAFU (toSNAFUHelper (2 * pwr - x) (n - 1))
            else ['1'] ++ toSNAFUHelper (x - pwr) (n - 1)
              where pwr = 5 ^ (n - 1)

main = do
  content <- readFile "input.txt"
  let s = sum $ map _SNAFUToDecimal (lines content)
  print s
  putStrLn $ toSNAFU s
