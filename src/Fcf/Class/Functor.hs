{-# LANGUAGE
    DataKinds,
    PolyKinds,
    TypeFamilies,
    TypeInType,
    TypeOperators,
    UndecidableInstances #-}

module Fcf.Class.Functor
  ( Map
  ) where

import Fcf.Core (Exp, Eval)

-- | Type-level 'fmap' for type-level functors.
--
-- === __Example__
--
-- >>> import Fcf.Data.Nat
-- >>> import qualified GHC.TypeLits as TL
-- >>> data AddMul :: Nat -> Nat -> Exp Nat
-- >>> type instance Eval (AddMul x y) = (x TL.+ y) TL.* (x TL.+ y)
-- >>> :kind! Eval (Map (AddMul 2) '[0, 1, 2, 3, 4])
-- Eval (Map (AddMul 2) '[0, 1, 2, 3, 4]) :: [Nat]
-- = '[4, 9, 16, 25, 36]
data Map :: (a -> Exp b) -> f a -> Exp (f b)

-- []
type instance Eval (Map f '[]) = '[]
type instance Eval (Map f (a ': as)) = Eval (f a) ': Eval (Map f as)

-- Maybe
type instance Eval (Map f 'Nothing) = 'Nothing
type instance Eval (Map f ('Just a)) = 'Just (Eval (f a))

-- Either
type instance Eval (Map f ('Left x)) = 'Left x
type instance Eval (Map f ('Right a)) = 'Right (Eval (f a))

-- Tuples
type instance Eval (Map f '(x, a)) =
  '(x, Eval (f a))
type instance Eval (Map f '(x, y, a)) =
  '(x, y, Eval (f a))
type instance Eval (Map f '(x, y, z, a)) =
  '(x, y, z, Eval (f a))
type instance Eval (Map f '(x, y, z, w, a)) =
  '(x, y, z, w, Eval (f a))
