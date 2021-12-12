defmodule GenReport do
  alias GenReport.GetMonthName

  def build(report) do
    report
    |> File.stream!()
    |> Enum.map(fn line -> parse_line(line) end)
    |> get_report()
  end

  def build_stream(report) do
    report
    |> File.stream!()
    |> Enum.map(fn line -> parse_line(line) end)
  end

  def build_from_many(reports) do
    result =
      reports
      |> Task.async_stream(&build_stream/1)
      |> Enum.reduce([], fn {:ok, result}, _acc -> result end)
      |> get_report()

    {:ok, result}
  end

  defp parse_line(line) do
    [nome, horas_trabalhadas, dia, mes, ano] =
      line
      |> String.trim()
      |> String.split(",")

    horas_trabalhadas = String.to_integer(horas_trabalhadas)
    dia = String.to_integer(dia)
    mes = String.to_integer(mes)
    ano = String.to_integer(ano)

    [nome, horas_trabalhadas, dia, mes, ano]
  end

  defp get_report(list) do
    %{
      all_hours: get_all_hours(list),
      hours_per_month: hours_per_month(list),
      hours_per_year: hours_per_year(list)
    }
  end

  defp get_all_hours(list) do
    list
    |> Enum.reduce(%{}, fn line, all_hours -> sum_all_hours(line, all_hours) end)
  end

  defp sum_all_hours([nome, horas_trabalhadas | _], all_hours) do
    all_hours =
      all_hours
      |> Map.put(nome, Map.get(all_hours, nome, 0) + horas_trabalhadas)

    all_hours
  end

  defp hours_per_month(list) do
    list
    |> Enum.reduce(%{}, fn line, hours_per_month ->
      sum_hours_per_month(line, hours_per_month)
    end)
  end

  defp sum_hours_per_month(
         [nome, horas_trabalhadas, _dia, mes | _],
         hours_per_month
       ) do
    mes = GetMonthName.get_name_of(mes)

    person = Map.get(hours_per_month, nome, %{})

    person = Map.put(person, mes, Map.get(person, mes, 0) + horas_trabalhadas)

    hours_per_month = Map.put(hours_per_month, nome, person)

    hours_per_month
  end

  defp hours_per_year(list) do
    list
    |> Enum.reduce(%{}, fn line, hours_per_year ->
      sum_hours_per_year(line, hours_per_year)
    end)
  end

  defp sum_hours_per_year(
         [nome, horas_trabalhadas, _dia, _mes, year],
         hours_per_year
       ) do
    person = Map.get(hours_per_year, nome, %{})

    person = Map.put(person, year, Map.get(person, year, 0) + horas_trabalhadas)

    hours_per_year = Map.put(hours_per_year, nome, person)

    hours_per_year
  end
end
