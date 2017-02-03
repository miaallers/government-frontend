# View helper for all things related to parts as provided by
# the Parted module.
module PartHelper
  def part_path(slug, part = nil, edition = nil)
    path = "/#{slug}"
    path += "/#{part}" if part
    path += "?edition=#{edition}" if edition
    path
  end

  def previous_part_path(publication, part, edition)
    raise "No previous part" if publication.part_before(part).nil?
    part_path(publication.slug, publication.part_before(part).slug, edition)
  end

  def next_part_path(publication, part, edition)
    raise "No next part" if publication.part_after(part).nil?
    part_path(publication.slug, publication.part_after(part).slug, edition)
  end

  def part_number(parts, part)
    parts.index(part) + 1
  rescue => e
    Rails.logger.info "#{e.message} : #{parts.inspect} : #{part.inspect}"
    "-"
  end
end
