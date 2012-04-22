# Copyright (c) 2009 Steven Hammond, Cris Necochea, Joe Lind, Jeremy Weiskotten
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

module SurveysHelper
  def info_link(name, url)
    link_to name, url, :target => '_blank'
  end
  
  def main_point(text)
    "<a href=\"#\">#{text}&hellip;</a>"
  end

  def parameter_input form, parameter
    rational_attribute = parameter.to_s + '_rational_id'
    collection = Survey.options_for(parameter)
    label_method = "#{parameter}_label".to_sym

    form.input rational_attribute, :collection => collection,
      :include_blank => false,
      :as => :select,
      :value_method => :id,
      :label_method => label_method
  end

  def chart_columns(parameter)
    if parameter.to_sym == :n
      [0, 1, 2, 3, 4, '5-9', '10-99', '100-999', '1000-9999', '10000+']
    else
      Survey.options_for(parameter).map &:quotient_label
    end
  end

  # def chart_colors(parameter)
  #   num_values = case parameter
  #   when 'n'
  #     4
  #   else
  #     Survey.options_for(parameter).size
  #   end
  #   
  #   step = 128 / num_values
  #   colors = (0...num_values).to_a.map { |i| "rgb(#{[128+i*step, i*step, 0].join(',')})"}.reverse
  # end
  # 
  # def chart_options(parameter, dimension, options={})
  #   options[:parameter] = parameter
  #   options[:demographic] = dimension
  # 
  #   if :n == parameter.to_sym
  #     parameter_col = parameter.to_s
  #     options[:option_label_method] = :to_s
  #     options[:option_value_method] = :to_s
  #   else
  #     parameter_col ="#{parameter}_rational_id"
  #     options[:rational_options] = Survey.options_for(parameter)
  #     options[:option_label_method] = :quotient_label
  #     options[:option_value_method] = :id
  #   end
  #   
  #   case dimension
  #   when :age
  #     options[:dimension] = AgeGroup.all + [AgeGroup.new(:id => nil, :description => 'Unknown')]
  #     options[:data] = Survey.report(parameter_col, :age_group_id)
  #     options[:dimension_key_method] = :id
  #     options[:dimension_label_method] = :description
  #   when :gender
  #     options[:dimension] = ['Male','Female',nil]
  #     options[:data] = Survey.report(parameter_col, :gender)
  #     options[:dimension_key_method] = :to_s
  #     options[:dimension_label_method] = :to_s
  #   else
  #     raise 'Invalid dimension'
  #   end
  # 
  #   options[:rational_options] ||= options[:data][:rational_options].sort_by{|k| k.to_s.split('over').last.split('-').first.to_i}
  #   
  #   return options
  # end
  # 
  # def chart(parameter, dimension, options={})
  #   render :partial => 'chart_set', :locals => chart_options(parameter, dimension, options)
  # end
  
  def data_format(num)
    if num > 9_999_999
      return '%0.2e' % num.to_f
    elsif num > 100
      return num.round.commify
    else
      return "%0.2f" % num.to_f
    end
  end
end
