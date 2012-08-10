class FailingTestJob
  def perform
    raise "this one fails"
  end
end
