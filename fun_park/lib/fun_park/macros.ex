defmodule FunPark.Macros do
  defmacro ord_for(for_struct, field) do
    quote do
      alias FunPark.Ord

      defimpl FunPark.Ord, for: unquote(for_struct) do
        def lt?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ) do
          Ord.lt?(v1, v2)
        end

        def le?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ) do
          Ord.le?(v1, v2)
        end

        def gt?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ) do
          Ord.gt?(v1, v2)
        end

        def ge?(
              %unquote(for_struct){unquote(field) => v1},
              %unquote(for_struct){unquote(field) => v2}
            ) do
          Ord.ge?(v1, v2)
        end
      end
    end
  end
end
