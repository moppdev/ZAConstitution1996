namespace Constitution1996API.Models
{
    public class FullSection
    {
        public int sectionID {get; set;} = 0;
        public string sectionTitle {get; set;} = "";

        public string? sectionText {get; set;} = null;

        public IEnumerable<Subsection>? subSections {get; set;} = null;

        public IEnumerable<Clause>? clauses {get; set;} = null;

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