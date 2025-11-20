struct CandidateModel {
    let name: String
    let imageName: String
    let location: String
    let experience: String

    static let sampleData: [CandidateModel] = [
        .init(name: "Shreya Sharma 26",
              imageName: "cand1",
              location: "Mumbai, India",
              experience: "5+ years experience"),

        .init(name: "Aarushi Mehta 24",
              imageName: "cand2",
              location: "Delhi, India",
              experience: "3+ years experience"),

        .init(name: "Priya Kapoor 28",
              imageName: "cand3",
              location: "Bangalore, India",
              experience: "7+ years experience")
    ]
}

