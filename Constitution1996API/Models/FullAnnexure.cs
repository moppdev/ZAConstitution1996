namespace Constitution1996API.Models
{
    // Model that returns a annexure with its contents
    public class FullAnnexure
    {
        // fields

        // sectionText, and annexureSubsections are nullable to reflect the following logic:
        // - If sectionText is null, it indicates that there are subsections present.
        // - If sectionText is not null, it means there are no subsections.
        public char AnnexureID {get; set;}
        public string AnnexureTitle {get; set;} = "";

        public IEnumerable<AnnexureSection>? AnnexureSections {get; set;} = null;

        public List<IEnumerable<AnnexureSubsection>>? AnnexureSubsections {get; set;} = null;

        // constructor to set the above values
        public FullAnnexure(char annexureID, string annexureTitle, IEnumerable<AnnexureSection>? annexureSections, List<IEnumerable<AnnexureSubsection>>? annexureSubsections)
        {
            this.AnnexureSubsections = annexureSubsections;
            this.AnnexureID = annexureID;
            this.AnnexureTitle = annexureTitle;
            this.AnnexureSections = annexureSections;
        }
    }
}