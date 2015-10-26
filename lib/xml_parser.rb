class XmlParser
  class << self
    def nokogiri_xml_to_hash(element)
      out_hash = {}
      return out_hash if element.nil?

      element.attributes.each { |k,_| out_hash[k] = element.attr(k) }

      element.elements.try(:each) do |elem|
        prop = nokogiri_xml_to_hash(elem)

        if prop.is_a?(Array) && prop.size > 1
          out_hash[elem.name] = prop
        else
          out_hash[elem.name] ||= []
          out_hash[elem.name].push(prop)
        end

        out_hash[elem.name].flatten!
      end

      return out_hash.values.flatten if out_hash.size < 2

      out_hash
    end
  end
end
