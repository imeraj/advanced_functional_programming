defprotocol FunPark.Monad do
  def map(monad_value, func)
  def bind(monad_value, fuc_returning_monad)
  def ap(monadic_func, monad_value)
end
