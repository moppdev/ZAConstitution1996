namespace Constitution1996API.Models
{
    // Model that returns a section with all its contents
    public class FullSection
    {
        // fields

    // sectionText, subSections, and clauses are nullable to reflect the following logic:
    // - If sectionText is null, it indicates that there are subsections present.
    // - Clauses are also nullable and depend on whether there are subsections with clauses.
    // - If sectionText is not null, it means there are no subsections or clauses.
        public int sectionID {get; set;} = 0;
        public string sectionTitle {get; set;} = "";

        public string? sectionText {get; set;} = null;

        public IEnumerable<Subsection>? subSections {get; set;} = null;

        public IEnumerable<Clause>? clauses {get; set;} = null;

        // constructor to set the above values
        public FullSection(int sectionID, string sectionTitle, string? sectionText, IEnumerable<Subsection>? subSections, IEnumerable<Clause>? clauses)
        {
            this.sectionID = sectionID;
            this.sectionTitle = sectionTitle;
            this.sectionText = sectionText;
            this.clauses = clauses;
            this.subSections = subSections;
        }
    }
}