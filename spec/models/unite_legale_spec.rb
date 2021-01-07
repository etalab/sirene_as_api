require 'rails_helper'

describe UniteLegale do
  it { is_expected.to have_many :etablissements }

  it 'has header_mapping' do
    expect(described_class.header_mapping).to include 'statutDiffusionUniteLegale' => :statut_diffusion
  end

  describe '#nullify_non_diffusable_fields' do
    context 'when diffusable' do
      subject { create :unite_legale }

      it 'does not nullify any fields' do
        copy = subject.as_json
        subject.nullify_non_diffusable_fields
        expect(subject.as_json).to eq copy
      end
    end

    context 'when non-diffusable' do
      subject { create :unite_legale, :non_diffusable }

      it 'nullify unauthorized fields' do
        subject.nullify_non_diffusable_fields
        subject.attributes.each_key do |attr|
          next if described_class::AUTHORIZED_FIELDS.include?(attr)

          expect(subject.send(attr)).to be_nil
        end
      end

      it 'does not nullify authorized fields' do
        subject.nullify_non_diffusable_fields
        described_class::AUTHORIZED_FIELDS.each do |attr|
          expect(subject.send(attr)).not_to be_nil
        end
      end
    end
  end

  describe '#numero_tva_intra' do
    # The computed VAT validation key shall be two digits length
    # and is padded with a leading 0 when needed.
    # Here is an example where the validation key should be "09" instead of "9"
    it 'is always 13 characters long' do
      entreprise = build(:unite_legale, siren: '504019662')

      expect(entreprise.numero_tva_intra).to eq('FR09504019662')
    end
  end
end
