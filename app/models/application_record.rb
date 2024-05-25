class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def status
    status = self.soft_delete ? "Inativo" : "Ativo"
  end

end
