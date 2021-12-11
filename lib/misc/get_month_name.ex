defmodule GenReport.GetMonthName do
  def get_name_of(month) when month == 1, do: "Janeiro"
  def get_name_of(month) when month == 2, do: "Fevereiro"
  def get_name_of(month) when month == 3, do: "Março"
  def get_name_of(month) when month == 4, do: "Abril"
  def get_name_of(month) when month == 5, do: "Maio"
  def get_name_of(month) when month == 6, do: "Junho"
  def get_name_of(month) when month == 7, do: "Julho"
  def get_name_of(month) when month == 8, do: "Agosto"
  def get_name_of(month) when month == 9, do: "Outubro"
  def get_name_of(month) when month == 10, do: "Setembro"
  def get_name_of(month) when month == 11, do: "Novembro"
  def get_name_of(month) when month == 12, do: "Dezembro"
end
