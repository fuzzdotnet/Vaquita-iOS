import Foundation

// Data source for Vaquita Facts

let factsData: [VaquitaFact] = [
    VaquitaFact(
        id: "fact1",
        title: "Smallest Marine Mammal",
        content: "The vaquita is the smallest cetacean, reaching lengths of only 4-5 feet (1.2-1.5 m) and weighing up to 120 pounds (55 kg).",
        imageAsset: "vaquita_size_comparison", // Make sure you have this asset
        category: .biology
    ),
    VaquitaFact(
        id: "fact2",
        title: "Critically Endangered",
        content: "The vaquita is listed as Critically Endangered by the IUCN, primarily due to entanglement in illegal gillnets used for fishing totoaba.",
        imageAsset: "gillnet", // Make sure you have this asset
        category: .threats,
        learnMoreURL: URL(string: "https://www.worldwildlife.org/species/vaquita")
    ),
    VaquitaFact(
        id: "fact3",
        title: "Endemic Habitat",
        content: "Vaquitas are found only in a small area in the northern part of the Gulf of California (Sea of Cortez), Mexico.",
        imageAsset: "vaquita_habitat_map", // Make sure you have this asset
        category: .habitat
    ),
    // Add more facts here!
    // VaquitaFact(id: "fact4", title: "...", content: "...", category: .conservation),
] 